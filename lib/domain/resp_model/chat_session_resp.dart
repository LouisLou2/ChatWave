import 'dart:convert';

import '../entity/chat_session.dart';

class ChatSessionResp {
  final List<ChatSession> chatSessions;

  ChatSessionResp({required this.chatSessions});

  factory ChatSessionResp.fromJson(Map<String, dynamic> json, userId) {
    return ChatSessionResp(
      chatSessions: List<ChatSession>.from(json['session_list'].map((chatSession) => ChatSession.fromJson(chatSession,userId))),
    );
  }
}