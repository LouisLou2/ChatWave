import 'dart:convert';

import 'package:chat_wave/domain/entity/message_piece.dart';

class MessagePieceSI{
  final int sessionId;
  final String title;
  final int type;
  final String content;
  final bool isEnd;

  MessagePieceSI({
    required this.sessionId,
    required this.title,
    required this.type,
    required this.content,
    required this.isEnd
  });

  // static MessagePieceSI fromJsonStr(String jsonStr){
  //   final obj = jsonDecode(jsonStr);
  //   return MessagePieceSI(
  //     sessionId: obj['sessionId'],
  //     title: obj['title'],
  //     type: obj['type'],
  //     content: obj['content'],
  //     isEnd: obj['isEnd']
  //   );
  // }
  MessagePieceSI.fromJson(Map<String, dynamic> json)
      : sessionId = json['session_id'],
        title = json['title'],
        type = json['type'],
        content = json['content'],
        isEnd = json['isEnd'];

  MessagePiece toMessagePiece(){
    return MessagePiece(
      type: type,
      content: content,
      isEnd: isEnd
    );
  }
}