import '../../../domain/entity/chat_session.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/util_model/res_info.dart';

abstract class ChatNetDs{
  Future<Result<List<ChatSession>>> getRecentChats({required int offset, required int num,required int userId});
  Future<Result<List<Message>>> getMessages({required int sessionId, required int offset, required int num});
}