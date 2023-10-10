import 'dart:convert';

//import 'dart:developer';
//import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:myfirstpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../utils/response.dart';

final String jwtSectetKey = "D6VXp0R2RCsHPhwLgzDTxgu1Ejg1ZuQ3lz7S_FWbfaU=";

class UserEndpoint extends Endpoint {
  Future<Map<String, dynamic>> registerUser(
      Session session, UserData user) async {
    try {
      var emailAlreadyExist = await UserData.find(
        session,
        where: (p) => p.email.equals(user.email),
      );

      if (emailAlreadyExist.isEmpty) {
        final jwt = JWT(
          // Payload
          {},
          issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
        );
        var token = jwt.sign(SecretKey(jwtSectetKey));
        print('Signed token: $token\n');

        String password = user.password;
        final bytes = utf8.encode(password);
        final hash = sha256.convert(bytes);
        user.password = hash.toString();
        user.token = token;
        await UserData.insert(session, user);
        return Response(
                statusCode: 200,
                body: user,
                message: "Registration successful.",
                userMsg: "Registration successful")
            .toJson();
      } else {
        return Response(
                statusCode: 500,
                body: {
                  "username": user.username,
                  "email": user.email,
                },
                message: "Registration is unsuccessful. Email id already exist",
                userMsg: "Email id already exist")
            .toJson();
      }
    } catch (e) {
      // log('ERROR $e');
      return Response(
        statusCode: 500,
        message: e.toString(),
        userMsg: e.toString(),
      ).toJson();
    }
  }

  Future<Map<String, dynamic>> loginUser(
      Session session, LoginData login) async {
    try {
      var emailExist = await UserData.find(
        session,
        where: (p) => p.email.equals(login.email),
      );

      if (emailExist.isNotEmpty) {
        String password = login.password;
        final bytes = utf8.encode(password);

        final hash = sha256.convert(bytes);
        String hashedPassword = hash.toString();

        if (hashedPassword == emailExist[0].password) {
          final jwt = JWT(
            // Payload
            {
              'user': emailExist[0],
            },
            issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
          );
          var token = jwt.sign(SecretKey(jwtSectetKey),
              expiresIn: Duration(seconds: 20));
          print('Signed token: $token\n');
          emailExist[0].token = token;
          UserData.update(session, emailExist[0]);
          final token_status = verifyToken(session, emailExist[0].token!);
          print("token status :${token_status.toString()}");
          await LoginData.insert(
              session, LoginData(email: login.email, password: hashedPassword));
          return Response(
            statusCode: 200,
            body: emailExist[0],
            message: "User login is successful.",
            userMsg: "Logged In successfully",
          ).toJson();
        }
      }
      return Response(
              statusCode: 500,
              body: [],
              message: "Login Unsuccessful",
              userMsg: "Login Credential are Invalid")
          .toJson();
    } catch (e) {
      return Response(
              statusCode: 500, message: e.toString(), userMsg: e.toString())
          .toJson();
    }
  }

  Future<Map<String, dynamic>> verifyToken(
      Session session, String tokendata) async {
    try {
      final jwt = JWT.verify(tokendata, SecretKey(jwtSectetKey));
      return Response(statusCode: 200, body: jwt.payload).toJson();
    } on JWTExpiredException {
      return Response(statusCode: 401, body: "Token Expired").toJson();
    } on JWTException catch (e) {
      return Response(
              statusCode: 500, message: e.toString(), userMsg: e.toString())
          .toJson();
    }
  }
}
