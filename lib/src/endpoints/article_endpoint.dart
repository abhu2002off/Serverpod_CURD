import 'package:myfirstpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class ArticleEndpoint extends Endpoint {
  Future<List<Article>> getArticle(Session session, {String? keyword}) async {
    return await Article.find(session,
        where: (t) =>
            keyword != null ? t.title.like('%$keyword%') : Constant(true));
  }

  Future<bool> addArticle(Session session, Article article) async {
    await Article.insert(session, article);
    return true;
  }

  Future<bool> deleteArticle(Session session, int id) async {
    var result = await Article.delete(session, where: (t) => t.id.equals(id));
    return result == 1;
  }

  Future<bool> updateArticle(Session session, Article article) async {
    var result = await Article.update(session, article);
    return result;
  }

  //fetch weather info
  Future<WeatherInfo> getWeatherInfo(Session session, int cityId) async {
    var weatherkey = 'weather-$cityId';

    var weatherInfo =
        await session.caches.local.get(weatherkey) as WeatherInfo?;
    if (weatherInfo == null) {
      //!Log analytical Data
      session.log('city-$cityId', level: LogLevel.info);
      //API call to fetch data
      try {
        await Future.delayed(Duration(seconds: 1));
      } on Exception catch (e) {
        session.log('Weather Api Error', exception: e, level: LogLevel.error);
      }
      //Parsing response to model
      weatherInfo = WeatherInfo(temperature: 24);
      //saving the data in cache
      session.caches.local
          .put(weatherkey, weatherInfo, lifetime: Duration(minutes: 10));
    }
    return WeatherInfo(temperature: 24);
  }
}
