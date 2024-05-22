import 'package:isar/isar.dart';
part 'chat_session.g.dart';

@collection
class ChatSession{
  Id id=Isar.autoIncrement;

  @Index(unique: true)
  int sessionId;

  String title;

  @Index(composite: [CompositeIndex('lastMsgTime')])
  int userId;

  DateTime lastMsgTime;

  ChatSession({
    required this.sessionId,
    required this.title,
    required this.userId,
    required this.lastMsgTime
  });

  ChatSession.fromJson(Map<String, dynamic> json,this.userId)
      : sessionId = json['sessionId'],
        title = json['title'],
        lastMsgTime = DateTime.parse(json['time']);
}