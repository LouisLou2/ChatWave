import 'package:chat_wave/datasource/db/manage/db_manager.dart';
import 'package:chat_wave/domain/entity/chat_session.dart';
import 'package:chat_wave/domain/entity/message.dart';
import 'package:chat_wave/domain/util_model/res_info.dart';
import 'package:chat_wave/helper/global_exception_helpe.dart';
import 'package:isar/isar.dart';

import '../interface/chat_db_ds.dart';

class ChatDbDsImpl extends ChatDbDs {
  final Isar db = DBManager.db;

  @override
  Future<Result<List<Message>>> getMessages({required int sessionId, required int offset, required int num}) async {
    try{
      return Result.success(
        await db.messages.where().
        sessionIdEqualTo(sessionId).
        sortByTimeDesc().
        offset(offset).
        limit(num).
        findAll(),
      );
    }catch(e){
      return GlobalExceptionHelper.getErrorResInfo(e);
    }
  }

  @override
  Future<Result<List<ChatSession>>> getRecentChats({required int offset, required int num, required int userId})async {
    try{
      return Result.success(
        await db.chatSessions.where().
        userIdEqualToAnyLastMsgTime(userId).
        sortByLastMsgTimeDesc().
        offset(offset).
        limit(num).
        findAll(),
      );
    }catch(e){
      return GlobalExceptionHelper.getErrorResInfo(e);
    }
  }

  @override
  Future<void> saveMessage(Message message) async{
    db.writeTxn(() async{
      db.messages.put(message);
    });
  }

  @override
  Future<void> giveCorrectSessionId(int oldId, int newId) {
    return db.writeTxn(() async{
      final messages = await db.messages.where().sessionIdEqualTo(oldId).findAll();
      for(final message in messages){
        message.sessionId = newId;
        db.messages.put(message);
      }
    });
  }
}