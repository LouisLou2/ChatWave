import '../entity/message.dart';

class MessageResp {
  List<Message> messages;

  MessageResp({required this.messages});

  factory MessageResp.fromJson(Map<String, dynamic> json, int sessionId) {
    List<dynamic>messageList = json['message_list'] as List<dynamic>;
    return MessageResp(
      messages: List<Message>.from(
        messageList.map((message) => Message.fromJson(message, sessionId)),
      ),
    );
  }
}