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

  MessagePieceSI.fromJson(Map<String, dynamic> json)
      :sessionId = json['sessionid'],
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