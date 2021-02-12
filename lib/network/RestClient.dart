import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'RestClient.g.dart';

///after every edit run "flutter pub run build_runner build --delete-conflicting-outputs" in terminal to rebuild restclient.g.dart file

@RestApi(baseUrl: "http://192.168.4.1/")
//@RestApi(baseUrl: "http://192.168.0.25/")
abstract class RestClient {

  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/manual")
  @FormUrlEncoded()
  Future<HttpResponse> manualSwitch(@Field("c") int c, @Field("d") String d, @Field("i") int i);

  @POST("/wifi")
  @FormUrlEncoded()
  Future<HttpResponse> remoteSettings();

  @GET("/serial")
  @FormUrlEncoded()
  Future<HttpResponse> serialInfo();

  @POST("/wifisave")
  @FormUrlEncoded()
  Future<HttpResponse> remoteSettingsSave(
      @Field("s") String s, @Field("p") String p);

  @FormUrlEncoded()
  @POST("/radvancedmanual")
  Future<HttpResponse> avanceSwitch(@Body() Map<String, dynamic> hashFields);

  @FormUrlEncoded()
  @POST("/rclock")
  Future<HttpResponse> avanceAlarm(@Body() Map<String, dynamic> hashFields);//minuteur
}