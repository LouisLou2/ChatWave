/*-------------------event------------------------*/
import 'dart:async';

import 'package:chat_wave/constant/test_data.dart';
import 'package:chat_wave/domain/entity/message_piece.dart';
import 'package:chat_wave/feature/chat/bloc/chat_session_bloc.dart';
import 'package:chat_wave/respository/interface/chat_rep.dart';
import 'package:chat_wave/usecase/requester/interface/chat_requester.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/entity/chat_session.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/resp_model/message_piece_with_session_info.dart';
import '../repository/chat_history_rep.dart';

sealed class ChatActionEvent {
  const ChatActionEvent();
}

class OpenNewSessionPage extends ChatActionEvent {
  const OpenNewSessionPage();
}

class OpenExistSessionPage extends ChatActionEvent {
  ChatSession session;
  OpenExistSessionPage(this.session);
}

class SendFirstQuery extends ChatActionEvent {
  final String query;
  SendFirstQuery(this.query);
}

class MsgPieceWithSessionInfoArrived extends ChatActionEvent {
  final MessagePieceSI messagePieceSI;
  MsgPieceWithSessionInfoArrived(this.messagePieceSI);
}

class SendQuery extends ChatActionEvent {
  final String query;
  final int sessionId;
  SendQuery(this.query,this.sessionId);
}

class StreamOpened extends ChatActionEvent {
  StreamSubscription streamSubscription;
  Message queryMsg;
  StreamOpened({required this.streamSubscription, required this.queryMsg});
}

class MsgPieceArrived extends ChatActionEvent {
  final MessagePiece messagePiece;
  MsgPieceArrived(this.messagePiece);
}

class MsgPieceOver extends ChatActionEvent {
  const MsgPieceOver();
}

class TerminateStream extends ChatActionEvent {
  const TerminateStream();
}

/*---------------------------state------------------------------*/
sealed class ChatActionState extends Equatable {
  const ChatActionState();
}

class InitialChatActionState extends ChatActionState {
  const InitialChatActionState();
  @override
  List<Object?> get props => [];
}

class WaitingForFirstQuery extends ChatActionState {
  const WaitingForFirstQuery();
  @override
  List<Object?> get props => [];
}

class WaitingForQuery extends ChatActionState {
  const WaitingForQuery();
  @override
  List<Object?> get props => [];
}

class ReceivingPieces extends ChatActionState {
  const ReceivingPieces();
  @override
  List<Object?> get props => [];
}

// class ChatActionFailure extends ChatActionState {
//   const ChatActionFailure();
//   @override
//   List<Object?> get props => [];
// }

/*--------------------bloc----------------------*/
class ChatActionBloc extends Bloc<ChatActionEvent, ChatActionState> {

  int invalidSessionId=-1;

  final ChatRequester _chatRequester = GetIt.I<ChatRequester>();
  final ChatRep _chatRep = GetIt.I<ChatRep>();
  final ChatHistoryStateRep _chatHisStateRep = GetIt.I<ChatHistoryStateRep>();

  late StreamSubscription _streamSubscription;//目前这个正在进行的消息的订阅对象

  ChatActionBloc() : super(const InitialChatActionState()) {
    on<OpenNewSessionPage>(_onOpenNewSessionPage);
    on<OpenExistSessionPage>(_onOpenExistSessionPage);
    on<SendFirstQuery>(_onSendFirstQuery);
    on<MsgPieceWithSessionInfoArrived>(_onMsgPieceWithSessionInfoArrived);

    on<SendQuery>(_onSendQuery);
    on<StreamOpened>(_onStreamOpened);
    on<MsgPieceArrived>(_onMsgPieceArrived);
    on<TerminateStream>(_onTerminateStream);
    on<MsgPieceOver>(_onMsgPieceOver);
  }

  void _onOpenNewSessionPage(OpenNewSessionPage event, Emitter<ChatActionState> emit) {
    emit(const WaitingForFirstQuery());
  }

  void _onOpenExistSessionPage(OpenExistSessionPage event, Emitter<ChatActionState> emit) {
    _chatHisStateRep.nowSession = event.session;
    emit(const WaitingForQuery());
  }

  void _onSendFirstQuery(SendFirstQuery event, Emitter<ChatActionState> emit) {
    // 包装好消息
    Message msg = Message(
      sessionId: invalidSessionId,
      role: true,
      pieces: [MessageBase(
          type: MessageType.pureText,
          content: event.query,
        )
      ],
      time: DateTime.now(),
    );
    // 开始使用requester发送消息
    _chatRequester.startASession(
      query: event.query,
      onFirstPieceArrived: (MessagePieceSI piece){
        add(
          MsgPieceWithSessionInfoArrived(piece),
        );
      },
      onSubsPieceArrived: (MessagePiece piece){
        add(
          MsgPieceArrived(piece),
        );
      },
      onOver: (){
        add(const MsgPieceOver());
      },
      onStreamOpened: (StreamSubscription streamSubscription){
        add(
          StreamOpened(
            streamSubscription: streamSubscription,
            queryMsg: msg,
          ),
        );
      },
    );
  }

  void _onMsgPieceWithSessionInfoArrived(MsgPieceWithSessionInfoArrived event, Emitter<ChatActionState> emit) {
    MessagePieceSI piece = event.messagePieceSI;
    ChatSession session = ChatSession(
      sessionId: piece.sessionId,
      userId: TestData.testUserId,
      title: piece.title,
      lastMsgTime: DateTime.now(),
    );
    // 更新状态记录
    _chatHisStateRep.nowSession = session;
    _chatHisStateRep.setSessionIdForTmpMsg();
    // 在流被打开的时候，数据库中也存了这条记录，现在要将他的sessionId改成正确的
    _chatRep.giveCorrectSessionId(invalidSessionId, session.sessionId);
    // 通知ChatSessionBloc
    GetIt.I<ChatSessionBloc>().add(NewSessionCreated(session));

    add(
      MsgPieceArrived(
        piece.toMessagePiece(),
      ),
    );
  }

  void _onSendQuery(SendQuery event, Emitter<ChatActionState> emit) {
    // 包装好消息
    Message msg = Message(
      sessionId: _chatHisStateRep.nowSession.sessionId,
      role: true,
      pieces: [MessageBase(
          type: MessageType.pureText,
          content: event.query,
        )
      ],
      time: DateTime.now(),
    );
    // 开始使用requester发送消息
    _chatRequester.sendAQuery(
      sessionId: event.sessionId,
      query: event.query,
      onStreamOpened: (StreamSubscription streamSubscription){
        add(
            StreamOpened(
              streamSubscription: streamSubscription,
              queryMsg: msg,
            ),
        );
      },
      onOver: (){
        add(const MsgPieceOver());
      },
      onPieceArrived: (MessagePiece piece){
        add(
          MsgPieceArrived(piece),
        );
      },
    );
  }

  void _onStreamOpened(StreamOpened event, Emitter<ChatActionState> emit) {
    // 只要连接真正建立了,才将用户的query插入
    _chatHisStateRep.addNewMessage(event.queryMsg);
    _chatRep.saveMessage(event.queryMsg);
    // 应该先插入一条等待数据到达的消息
    add(
      MsgPieceArrived(
        MessagePiece.waiting(),
      ),
    );
    _streamSubscription = event.streamSubscription;
    // 进入听数据，不断接受的状态
    emit(const ReceivingPieces());
  }

  void _onMsgPieceArrived(MsgPieceArrived event, Emitter<ChatActionState> emit) {
    MessagePiece piece = event.messagePiece;
    // 更新状态记录
    _chatHisStateRep.appendNewMessagePiece(piece);// 此方法会自动处理isEnd,所以再这一步无需多考虑
    // 如果是最后一条piece,就要插入到数据库, 整条消息就要插入到数据库
    if(piece.isEnd && piece.type != MessageType.waitingSign){
      _chatRep.saveMessage(_chatHisStateRep.messages.last);
      emit(const ReceivingPieces());
      emit(const WaitingForQuery());
    }else{
      emit(const ReceivingPieces());
    }
  }

  void _onTerminateStream(TerminateStream event, Emitter<ChatActionState> emit) {
    _streamSubscription.cancel();
    // 流停止监听，但是还要主动发出一个
    add(
        MsgPieceArrived(
          MessagePiece.cancel(),
        ),
    );
    // TODO: 其实除了这里停止订阅，也要通知服务端不要再产生数据了
    emit(const WaitingForQuery());
  }

  void _onMsgPieceOver(MsgPieceOver event, Emitter<ChatActionState> emit) {
    // TODO:
    // 先改变_chatHisStateRep的状态
    _chatHisStateRep.onTheMessageOver();
    // 存入数据库
    _chatRep.saveMessage(_chatHisStateRep.messages.last);
    emit(const WaitingForQuery());
  }
}