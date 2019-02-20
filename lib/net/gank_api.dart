import 'package:dio/dio.dart';

class GankApi {
  /// gank api urls.
  static const String API_SPECIAL_DAY = "http://gank.io/api/day/";
  static const String API_DATA = "http://gank.io/api/data/";
  static const String API_TODAY = "http://gank.io/api/today";
  static const String API_HISTORY = "http://gank.io/api/day/history";
  static const String API_HISTORY_CONTENT = "http://gank.io/api/history/content";

  ///Dio client.
  static final Dio dio = new Dio();

  ///获取最新一天的数据
  Future getTodayData() async {
    Response response = await dio.get(API_TODAY);
    return response.data;
  }

  ///获取指定日期的数据 [date:指定日期]
  Future getSpecialDayData(String date) async {
    Response response =
        await dio.get(API_SPECIAL_DAY + date.replaceAll("-", "/"));
    return response.data;
  }

  ///获取分类数据 [category:分类, page: 页数, count:每页的个数]
  Future getCategoryData(String category, int page, {count = 20}) async {
    String url = API_DATA + category + "/$count/$page";
    Response response = await dio.get(url);
    return response.data;
  }

  ///获取所有的历史干货日期.
  Future getHistoryDateData() async {
    Response response = await dio.get(API_HISTORY);
    return response.data;
  }

  ///获取所有的历史干货.
  Future<List> getHistoryContentData(int page, {count = 20}) async {
    Response response = await dio.get(API_HISTORY_CONTENT + '/$count/$page');
    return response.data['results'];
  }
}
