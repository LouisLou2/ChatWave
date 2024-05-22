import 'package:chat_wave/domain/entity/chat_session.dart';
import 'package:chat_wave/domain/entity/message.dart';

import '../../../domain/util_model/res_info.dart';

abstract class ChatDbDs{
  Future<Result<List<ChatSession>>> getRecentChats({required int offset, required int num,required int userId});
  Future<Result<List<Message>>> getMessages({required int sessionId, required int offset, required int num});

  Future<void> saveMessage(Message message);
  Future<void> saveSession(ChatSession session);
  Future<void> giveCorrectSessionId(int oldId, int newId);
}