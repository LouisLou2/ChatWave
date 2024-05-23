import 'dart:async';
import 'package:chat_wave/domain/entity/message_piece.dart';
import 'package:chat_wave/domain/resp_model/message_piece_with_session_info.dart';
import 'package:flutter/material.dart';

abstract class ChatRequester{
  void sendAQuery({
    required String query,
    required int sessionId,
    required void Function(MessagePiece) onPieceArrived,
    required VoidCallback onOver,
    required void Function(StreamSubscription) onStreamOpened,
    required void Function() onError,
  });

  void startASession({
    required String query,
    required void Function(MessagePieceSI) onFirstPieceArrived,
    required void Function(MessagePiece) onSubsPieceArrived,
    required VoidCallback onOver,
    required void Function(StreamSubscription) onStreamOpened,
    required void Function() onError,
  });
}