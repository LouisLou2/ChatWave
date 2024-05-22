import 'dart:async';
import 'dart:convert';
import 'package:chat_wave/datasource/network/manage/network_path_collector.dart';
import 'package:chat_wave/domain/entity/message_piece.dart';
import 'package:chat_wave/domain/resp_model/message_piece_with_session_info.dart';
import 'package:eventflux/client.dart';
import 'package:eventflux/enum.dart';
import 'package:eventflux/models/response.dart';
import 'package:flutter/material.dart';

import '../interface/chat_requester.dart';

class ChatRequesterImple extends ChatRequester {
  //final Dio _reqDio = NetworkManager.normalDio;
  @override
  void sendAQuery({
    required String query,
    required void Function(MessagePiece) onPieceArrived,
    required VoidCallback onOver,
    required void Function(StreamSubscription) onStreamOpened,
  }) {
    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      NetworkPathCollector.chat,
      onSuccessCallback: (EventFluxResponse? response) {
        if(response?.stream==null){
          return;
        }
        StreamSubscription subsc = response!.stream!.listen(
          (event) {
            dynamic data = jsonDecode(event.data);
            MessagePiece piece = MessagePiece.fromJsonNotEnd(data);
            onPieceArrived(piece);
          },
          onDone: onOver,
        );
        onStreamOpened(subsc);
      },
    );
  }

  @override
  void startASession({required String query, required void Function(MessagePieceSI p1) onFirstPieceArrived, required void Function(MessagePiece p1) onSubsPieceArrived, required VoidCallback onOver, required void Function(StreamSubscription p1) onStreamOpened}) {
    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      NetworkPathCollector.new_chat_session,
      onSuccessCallback: (EventFluxResponse? response) {
        if(response?.stream==null){
          return;
        }
        StreamSubscription subsc = response!.stream!.listen(
          (event) {
            dynamic data = jsonDecode(event.data);
            if(data['sessionId']!=null){
              MessagePieceSI piece = MessagePieceSI.fromJson(data);
              onFirstPieceArrived(piece);
            }else{
              MessagePiece piece = MessagePiece.fromJsonNotEnd(data);
              onSubsPieceArrived(piece);
            }
          },
          onDone: onOver,
        );
        onStreamOpened(subsc);
      },
    );
  }
}