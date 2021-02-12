import 'package:dio/dio.dart';

import 'RestClient.dart';

class RestApi{
  static String BASE_URL_PART = "192.168.4";
  static String WEBSOCKET_URL_PART = "ws://websocket.mikroair.com:8080?token=";

  static RestClient createClient({String url}) {
    Dio dio = Dio();
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.sendTimeout = 10000;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("JEANPAUL NETWORK ${options.headers}");
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) {
      print("JEANPAUL IN ERROR ${error.message}");
      return error;
    }));

    dio.interceptors.add(LogInterceptor(requestBody: true,responseBody: true));

    //baseurl can be set by user, so change api request method signature
    if(url != null){
      return RestClient(dio,baseUrl: url);
    }else{
      return RestClient(dio);
    }
  }
}