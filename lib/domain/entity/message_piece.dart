import 'package:chat_wave/domain/entity/message.dart';

import '../../constant/app_strings.dart';

class MessagePiece{
  //int messageId;// 这个piece所属的message的id
  //int messageSeq;// 由于websocket有序，此字段不需要
  int type;//表示这一个piece的类型，0表示文字，及表示content字段是纯文本，1表示图片，content字段是图片的url，2表示文件，content字段是文件的url
  String content;
  bool isEnd;

  MessagePiece({
    required this.type,
    required this.content,
    required this.isEnd
  });

  MessagePiece.fromJsonNotEnd(Map<String, dynamic> json)
      :type = json['type'],
        content = json['content'],
        isEnd = false;

  MessagePiece.fromJson(Map<String, dynamic> json)
      :type = json['type'],
        content = json['content'],
        isEnd = json['isEnd'];

  MessagePiece.waiting():
    type = MessageType.waitingSign,
    content = AppStrs.waitingForResp,
    isEnd = true;

  MessagePiece.cancel():
    type = MessageType.cancelSign,
    content = AppStrs.answerCanceled,
    isEnd = true;

  factory MessagePiece.toPureText({required MessagePiece piece, required bool isEnd}){
    return MessagePiece(
      type: MessageType.pureText,
      content: piece.content,
      isEnd: isEnd,
    );
  }
}