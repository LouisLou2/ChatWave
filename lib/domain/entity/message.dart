import 'package:isar/isar.dart';

import 'message_piece.dart';
part 'message.g.dart';

class MessageType{
  static const int pureText = 0;
  static const int imageUrl = 1;
  static const int fileUrl = 2;
  static const int pluginJson = 3;
  static const int waitingSign = 4;// 客户端等待占位类型，例如content是一条消息"waiting for resp..."
  static const int cancelSign = 5;// 用户主动取消后，给出的一条提醒消息，例如content是"answer canceled"
}

@embedded
class MessageBase{
  int? type;
  String? content;

  MessageBase({
    this.type,
    this.content
  });

  factory MessageBase.fromJson(Map<String, dynamic> json) {
    return MessageBase(
      type: json['type'],
      content: json['content']
    );
  }

  factory MessageBase.fromPiece(MessagePiece piece){
    return MessageBase(
      type: piece.type,
      content: piece.content
    );
  }

  bool get isText => type== MessageType.pureText;
  bool get isImageUrl => type== MessageType.imageUrl;
}

@collection
class Message{
  Id id=Isar.autoIncrement;

  @Index()
  int sessionId;

  bool role;// 1:user, 0:model

  List<MessageBase> pieces;//消息的内容，可能是文字，图片，文件

  DateTime time;

  Message({
    required this.sessionId,
    required this.role,
    required this.pieces,
    required this.time
  });

  factory Message.fromJson(Map<String, dynamic> json, int sessionId) {
    List<dynamic>pieces = json['message_block'] as List<dynamic>;
    return Message(
      sessionId: sessionId,
      role: json['role'],
      pieces: List<MessageBase>.from(
        pieces.map((piece) => MessageBase.fromJson(piece)),
      ),
      time: DateTime.parse(json['time'])
    );
  }

  bool get justText{
    //如果是纯文字，那么一定piece的长度只有1
    for(final piece in pieces){
      if(piece.type!=MessageType.pureText){
        return false;
      }
    }
    return true;
  }
  bool get isSender => role;
}