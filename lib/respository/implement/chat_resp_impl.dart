import 'package:chat_wave/datasource/db/interface/chat_db_ds.dart';
import 'package:chat_wave/datasource/network/interface/chat_net_ds.dart';
import 'package:chat_wave/domain/entity/chat_session.dart';

import 'package:chat_wave/domain/entity/message.dart';

import 'package:chat_wave/domain/util_model/res_info.dart';
import 'package:get_it/get_it.dart';
import '../interface/chat_rep.dart';

class ChatRepImpl extends ChatRep {

  final ChatDbDs _chatDbDs = GetIt.I<ChatDbDs>();
  final ChatNetDs _chatNetDs = GetIt.I<ChatNetDs>();

  // @override
  // Future<Result<List<ChatSession>>> getFirstBunchRecentChats({required int num, required int userId, required int maxNumIfNetFailed}) async {
  //   Result<List<ChatSession>> res = await _chatNetDs.getRecentChats(offset: 0, num: num, userId: userId);
  //   if(res.isSuccess) return res;
  //   final dbRes= await _chatDbDs.getRecentChats(offset: 0, num: maxNumIfNetFailed);
  //   if(!dbRes.isSuccess) return dbRes;
  //   return Result(
  //     ResCode.DATA_NOT_NEW,
  //     data: dbRes.data,
  //   );
  // }

  @override
  Future<Result<List<ChatSession>>> getRecentChatsOnlyNet({required int offset, required int num, required int userId}) {
    return _chatNetDs.getRecentChats(offset: offset, num: num, userId: userId);
  }

  @override
  Future<Result<List<Message>>> getMessagesOnlyNet({required int sessionId, required int offset, required int num}) {
    return _chatNetDs.getMessages(sessionId: sessionId, offset: offset, num: num);
  }

  @override
  Future<Result<List<Message>>> getDefaultMessages({required int sessionId, required int num}) {
    return _chatDbDs.getMessages(sessionId: sessionId, offset: 0, num: num);
  }

  @override
  Future<Result<List<ChatSession>>> getDefaultRecentChats({required int num, required int userId}) {
    return _chatDbDs.getRecentChats(offset: 0, num: num,userId: userId);
  }

  @override
  Future<void> saveMessage(Message message) {
    return _chatDbDs.saveMessage(message);
  }

  @override
  Future<void> giveCorrectSessionId(int oldId, int newId) {
    return _chatDbDs.giveCorrectSessionId(oldId, newId);
  }

  @override
  Future<void> saveSession(ChatSession session) {
    return _chatDbDs.saveSession(session);
  }

  // @override
  // Future<Result<List<Message>>> getFirstBunchMessages({required int sessionId, required int num, required int maxNumIfNetFailed}) async {
  //   Result<List<Message>> res = await _chatNetDs.getMessages(sessionId: sessionId, offset: 0, num: num);
  //   if(res.isSuccess) return res;
  //   final dbRes= await _chatDbDs.getMessages(sessionId: sessionId, offset: 0, num: maxNumIfNetFailed);
  //   if(!dbRes.isSuccess) return dbRes;
  //   return Result(
  //     ResCode.DATA_NOT_NEW,
  //     data: dbRes.data,
  //   );
  // }
}