import '../entity/message.dart';

class MessageResp {
  List<Message> messages;

  MessageResp({required this.messages});

  factory MessageResp.fromJson(Map<String, dynamic> json, int sessionId) {
    return MessageResp(
      messages: List<Message>.from(
        json['message_list'].map((message) => Message.fromJson(message, sessionId)),
      ),
    );
  }
}