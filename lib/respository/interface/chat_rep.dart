import 'package:chat_wave/domain/entity/chat_session.dart';
import 'package:chat_wave/domain/entity/message.dart';

import '../../domain/util_model/res_info.dart';

abstract class ChatRep{
  Future<Result<List<ChatSession>>> getRecentChatsOnlyNet({required int offset, required int num,required int userId});
  Future<Result<List<ChatSession>>> getDefaultRecentChats({required int num,required int userId});

  //Future<Result<List<ChatSession>>> getFirstBunchRecentChats({required int num,required int userId,required int maxNumIfNetFailed});

  Future<Result<List<Message>>> getMessagesOnlyNet({required int sessionId, required int offset, required int num});
  Future<Result<List<Message>>> getDefaultMessages({required int sessionId, required int num});
  Future<void> saveMessage(Message message);
  Future<void> saveSession(ChatSession session);
  Future<void> giveCorrectSessionId(int oldId, int newId);

  //Future<Result<List<Message>>> getFirstBunchMessages({required int sessionId, required int num, required int maxNumIfNetFailed});
}