import 'package:chat_wave/datasource/network/manage/network_config.dart';
import 'package:chat_wave/datasource/network/manage/network_manager.dart';
import 'package:chat_wave/datasource/network/manage/network_path_collector.dart';
import 'package:chat_wave/domain/entity/chat_session.dart';

import 'package:chat_wave/domain/entity/message.dart';
import 'package:chat_wave/domain/resp_model/resp_body.dart';
import 'package:chat_wave/helper/global_exception_helpe.dart';
import 'package:dio/dio.dart';

import '../../../constant/rescode.dart';
import '../../../domain/resp_model/chat_session_resp.dart';
import '../../../domain/resp_model/message_resp.dart';
import '../../../domain/util_model/res_info.dart';
import '../interface/chat_net_ds.dart';

class ChatNetDsImpl extends ChatNetDs {

  final Dio _chatDio= NetworkManager.normalDio;

  @override
  Future<Result<List<Message>>> getMessages({required int sessionId, required int offset, required int num}) async {
    try{
      Response response= await  _chatDio.get(
        NetworkPathCollector.message,
        data:{
          'sessionId':sessionId,
          'offset':offset,
          'num':num,
        },
        options: NetworkConfig.json_json,
      );
      RespBody respBody= RespBody.fromJson(response.data);

      if(respBody.code==ResCode.SUCCESS){
        return Result.success(MessageResp.fromJson(respBody.data,sessionId).messages);
      }else{
        return Result.abnormal(respBody.code);
      }
    }catch(e){
      return GlobalExceptionHelper.getErrorResInfo(e);
    }
  }

  @override
  Future<Result<List<ChatSession>>> getRecentChats({required int offset, required int num,required int userId}) async{
    try{
      Response response= await  _chatDio.get(
        NetworkPathCollector.chat_session,
        data:{
          'offset':offset,
          'num':num,
        },
        options: NetworkConfig.json_json,
      );
      RespBody respBody= RespBody.fromJson(response.data);
      if(respBody.code==ResCode.SUCCESS){
        ChatSessionResp chatSessionResp = ChatSessionResp.fromJson(respBody.data,userId);
        return Result.success(chatSessionResp.chatSessions);
      }else{
        return Result.abnormal(respBody.code);
      }
    }catch(e){
      return GlobalExceptionHelper.getErrorResInfo(e);
    }
  }
}