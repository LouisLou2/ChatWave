import 'package:chat_wave/domain/entity/chat_session.dart';
import 'package:chat_wave/domain/entity/message.dart';
import 'package:chat_wave/domain/entity/user.dart';
import 'package:isar/isar.dart';
import '../../../usecase/path_manager.dart';

/*静态*/
class DBManager{
  static late final Isar _db;
  static Isar get db=>_db;

  static init() async {
    _db= await Isar.open(
      [
        UserSchema,
        MessageSchema,
        ChatSessionSchema,
      ],
      directory: PathManager.dbDir.path,
      inspector: true,
    );
  }
}