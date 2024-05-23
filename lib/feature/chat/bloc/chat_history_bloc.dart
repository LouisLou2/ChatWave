/*-------------------event------------------------*/
import 'package:chat_wave/constant/feature_const.dart';
import 'package:chat_wave/domain/util_model/res_info.dart';
import 'package:chat_wave/feature/chat/bloc/chat_session_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/entity/chat_session.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/entity/message_piece.dart';
import '../../../respository/interface/chat_rep.dart';
import '../../../ui/helper/toast_helper.dart';
import '../repository/chat_history_rep.dart';

sealed class ChatHistoryEvent {
  const ChatHistoryEvent();
}

class InitRetrieveHistory extends ChatHistoryEvent {
  ChatSession session;
  InitRetrieveHistory(this.session);
}

class OpenNewChatSession extends ChatHistoryEvent {
  const OpenNewChatSession();
}

class RetrieveChatHistory extends ChatHistoryEvent {
  const RetrieveChatHistory();
}

/*-------------------state--------------------*/
sealed class ChatHistoryState extends Equatable {
  const ChatHistoryState();
}

class ChatHistoryInitial extends ChatHistoryState {
  const ChatHistoryInitial();
  @override
  List<Object?> get props => [];
}

class ChatHistoryLoading extends ChatHistoryState {
  const ChatHistoryLoading();
  @override
  List<Object?> get props => [];
}

class ChatHistorySuccess extends ChatHistoryState {
  final int len;
  final SessionChangeFrom hisFrom;
  const ChatHistorySuccess({required this.len, required this.hisFrom});
  @override
  List<Object?> get props => [len, hisFrom];
}

class ChatHistoryFailure extends ChatHistoryState {
  const ChatHistoryFailure();
  @override
  List<Object?> get props => [];
}

/*--------------------bloc----------------------*/

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatRep _chatRep = GetIt.I<ChatRep>();
  final ChatHistoryStateRep _chatHisStateRep = GetIt.I<ChatHistoryStateRep>();

  ChatHistoryBloc() : super(const ChatHistoryInitial()) {
    on<OpenNewChatSession>(_openNewChatSession);
    on<InitRetrieveHistory>(_initRetrieveChatHistory);
    on<RetrieveChatHistory>(_retrieveChatHistory);
  }

  // 如果这里仍然返回ChatHistorySuccess(),会导致先前和现在的状态都是ChatHistorySuccess()，连buildWhen都不会被调用
  void _openNewChatSession(OpenNewChatSession event, Emitter<ChatHistoryState> emit) async {
    _chatHisStateRep.clear();
    emit(const ChatHistoryInitial());
  }

  void _initRetrieveChatHistory(InitRetrieveHistory event, Emitter<ChatHistoryState> emit) async {
    _chatHisStateRep.nowSession=event.session;
    emit(const ChatHistoryLoading());
    int sessionId = _chatHisStateRep.nowSession.sessionId;

    Result<List<Message>> res = await _chatRep.getDefaultMessages(
      sessionId: sessionId,
      num: FeatureConst.defHistoryChatSessionNum,
    );
    if (!res.isSuccess) {
      ToastHelper.showToasterWithRescode(res.resCode); // 几乎不可能失败
      emit(const ChatHistoryFailure());
    } else {
      _chatHisStateRep.initHistory(res.data!);
      emit(ChatHistorySuccess(
        len: _chatHisStateRep.messages.length,
        hisFrom: SessionChangeFrom.Local,
      ));
    }
    // 尝试从网络获取
    res = await _chatRep.getMessagesOnlyNet(
      sessionId: sessionId,
      offset: 0,
      num: FeatureConst.defHistoryChatMessageNum,
    );
    if (res.isSuccess) {
      _chatHisStateRep.initHistory(res.data!);
      emit(ChatHistorySuccess(
        len: _chatHisStateRep.messages.length,
        hisFrom: SessionChangeFrom.Net,
      ));
    } else {
      emit(const ChatHistoryFailure());
    }
  }

  void _retrieveChatHistory(RetrieveChatHistory event, Emitter<ChatHistoryState> emit) async {
    emit(const ChatHistoryLoading());
    int sessionId = _chatHisStateRep.nowSession.sessionId;
    Result<List<Message>> res = await _chatRep.getMessagesOnlyNet(
      sessionId: sessionId,
      offset: _chatHisStateRep.messages.length,
      num: FeatureConst.defHistoryChatMessagePage,
    );
    if (res.isSuccess) {
      _chatHisStateRep.addHistoryMessages(res.data!);
      emit(ChatHistorySuccess(
        len: _chatHisStateRep.messages.length,
        hisFrom: SessionChangeFrom.Net,
      ));
    } else {
      emit(const ChatHistoryFailure());
    }
  }
}
