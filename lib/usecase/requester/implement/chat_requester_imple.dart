import 'dart:async';
import 'dart:convert';
import 'package:chat_wave/datasource/network/manage/network_path_collector.dart';
import 'package:chat_wave/domain/entity/message_piece.dart';
import 'package:chat_wave/domain/resp_model/message_piece_with_session_info.dart';
import 'package:eventflux/client.dart';
import 'package:eventflux/enum.dart';
import 'package:eventflux/eventflux.dart';
import 'package:eventflux/models/response.dart';
import 'package:flutter/material.dart';

import '../interface/chat_requester.dart';

class ChatRequesterImple extends ChatRequester {
  //final Dio _reqDio = NetworkManager.normalDio;
  @override
  void sendAQuery({
    required String query,
    required int sessionId,
    required void Function(MessagePiece) onPieceArrived,
    required VoidCallback onOver,
    required void Function(StreamSubscription) onStreamOpened,
    required void Function() onError,
  }) {
    EventFlux.instance.connect(
      EventFluxConnectionType.get,
      NetworkPathCollector.chat,
      header: {
        'Content-Type': 'application/json',
      },
      body: {
        'query': query,
        'session_id': sessionId,
      },
      onSuccessCallback: (EventFluxResponse? response) {
        if(response?.stream==null){
          return;
        }
        StreamSubscription subsc = response!.stream!.listen(
          (event) {
            dynamic finalData = event.data.substring(0,event.data.length-1);
            dynamic data = jsonDecode(finalData);
            MessagePiece piece = MessagePiece.fromJsonNotEnd(data);
            onPieceArrived(piece);
            print(data['content']);
          },
          onDone: onOver,
        );
        onStreamOpened(subsc);
        print('@@@@@@@@@@@@@@invoked onStreamOpened(subsc);');
      },
      onError: (EventFluxException e){
        print('@@@@@@@@@@@@Error: ${e.message}');
        onError();
      }
    );
  }

  @override
  void startASession({
    required String query,
    required void Function(MessagePieceSI p1) onFirstPieceArrived,
    required void Function(MessagePiece p1) onSubsPieceArrived,
    required VoidCallback onOver,
    required void Function(StreamSubscription p1) onStreamOpened,
    required void Function() onError,
  }) {
    EventFlux.instance.connect(
      EventFluxConnectionType.post,
      header: {
        'Content-Type': 'application/json',
      },
      NetworkPathCollector.chat,
      body: {
        'query': query,
      },
      onSuccessCallback: (EventFluxResponse? response) {
        if(response?.stream==null){
          return;
        }
        StreamSubscription subsc = response!.stream!.listen(
          (event) {
            String finalData= event.data.substring(0,event.data.length-1);
            dynamic data = jsonDecode(finalData);
            if(data['session_id']!=null){
              MessagePieceSI piece = MessagePieceSI.fromJson(data);
              onFirstPieceArrived(piece);
              print(data['content']);
            }else{
              MessagePiece piece = MessagePiece.fromJsonNotEnd(data);
              onSubsPieceArrived(piece);
              print(data['content']);
            }
          },
          onDone: onOver,
        );
        onStreamOpened(subsc);
      },
      onError: (EventFluxException e){
        print('@@@@@@@@@@@@Error: ${e.message}');
        onError();
      }
    );
  }
}