
import '../../../../config/config.dart';
// 这些route是需要持久化保存的，以应对后端api的变化,但是目前先不做这些了

class NetworkPathCollector {
  static const String host = Configs.HOST;// server host
  static const String restfulAPI = ""; // restful api
  static const String userApi = "$host$restfulAPI";// dio的baseUrl，客户端一切请求都是基于这个baseUrl的
  /*------------------分类-------------------*/
  static const String chat_session = "/chat_session";
  static const String message = "/message";

  static const String new_chat_session = "/new_chat";
  static const String chat= "/chat";
}