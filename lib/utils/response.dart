import 'package:serverpod/serverpod.dart';

class Response implements SerializableEntity {
  int statusCode;
  Map<String, String>? headers;
  dynamic body;
  String? message;
  String? userMsg;

  Response(
      {required this.statusCode,
      this.headers,
      this.body,
      this.message,
      this.userMsg});

  @override
  Map<String, dynamic> allToJson() {
    // if (message != null) {
    return {
      'statusCode': statusCode,
      'body': body,
      'message': message,
      'user_msg': userMsg,
    };
    // } else {
    //   return {
    //     'statusCode': statusCode,
    //     'body': body,
    //   };
    // }
  }

  @override
  Map<String, dynamic> toJson() {
    // if (message != null) {
    return {
      'statusCode': statusCode,
      'body': body,
      'message': message,
      'user_msg': userMsg,
    };
    // } else {
    //   return {
    //     'statusCode': statusCode,
    //     'body': body,
    //   };
    // }
  }
}
