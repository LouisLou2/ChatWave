import 'package:chat_wave/constant/test_data.dart';
import 'package:dio/dio.dart';

import '../../../config/config.dart';

class NetworkConfig{

  static bool autoUseToken = true;// 自动将token加入到请求头
  static Duration defaultTimeout = const Duration(milliseconds: Configs.CONNECT_TIMEOUT);
  static Duration longerTimeout = const Duration(milliseconds: Configs.CONNECT_TIMEOUT*2);

  // 请求与返回类型的枚举
  static Options get formdata_json => Options(
    headers:{
      'Authorization': TestData.testToken,
    },
    contentType: Headers.multipartFormDataContentType,
    responseType: ResponseType.json,
  );
  static Options get  json_json => Options(
    headers:{
      'Authorization': TestData.testToken,
    },
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );
  static void init(){}
}