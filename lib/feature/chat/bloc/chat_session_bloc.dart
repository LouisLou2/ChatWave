/*--------------------event-----------------*/
import 'package:chat_wave/constant/feature_const.dart';
import 'package:chat_wave/domain/util_model/res_info.dart';
import 'package:chat_wave/ui/helper/toast_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../constant/test_data.dart';
import '../../../domain/entity/chat_session.dart';
import '../../../respository/interface/chat_rep.dart';
import '../repository/chat_history_rep.dart';
import 'chat_history_bloc.dart';

enum SessionChangeFrom{
  Local,
  Net,
  UserNow,
}

sealed class ChatSessionEvent{
  const ChatSessionEvent();
}

class InitRetrieveSession extends ChatSessionEvent{
  final int nowSessionId;
  const InitRetrieveSession({required this.nowSessionId});
}
class RetrieveChatSession extends ChatSessionEvent{
  const RetrieveChatSession();
}
class NewSessionCreated extends ChatSessionEvent{
  final ChatSession newSession;
  NewSessionCreated(this.newSession);
}
// class ChooseSession extends ChatSessionEvent{
//   ChatSession chosenSession;
//   ChooseSession(this.chosenSession);
// }

/*-------------------state--------------------*/
sealed class ChatSessionState extends Equatable{
  const ChatSessionState();
}

class ChatSessionInitial extends ChatSessionState{
  const ChatSessionInitial();
  @override
  List<Object?> get props => [];
}

class ChatSessionLoading extends ChatSessionState{
  const ChatSessionLoading();
  @override
  List<Object?> get props => [];
}

class ChatSessionSuccess extends ChatSessionState{
  final int nowIndex;
  final int len;
  final SessionChangeFrom changeFrom;
  const ChatSessionSuccess({required this.len, required this.changeFrom,required this.nowIndex});
  @override
  List<Object?> get props => [len, changeFrom,nowIndex];
}

class ChatSessionFailure extends ChatSessionState{
  const ChatSessionFailure();
  @override
  List<Object?> get props => [];
}

/*-------------------state_repository-----------*/
class ChatSessionStateRep {
  List<ChatSession> sessions = [];
  int nowIndex=0;
  void setSessions(List<ChatSession> chats) {
    sessions = chats;
  }
  void setNowIndex(int index){
    nowIndex=index;
  }
  void addSessions(List<ChatSession> chats) {
    sessions.addAll(chats);// 追加
  }
}
/*--------------------bloc----------------------*/
class ChatSessionBloc extends Bloc<ChatSessionEvent, ChatSessionState>{

  final ChatRep _chatRep = GetIt.I<ChatRep>();
  final ChatSessionStateRep _stateRep = GetIt.I<ChatSessionStateRep>();
  final ChatHistoryStateRep _historyStateRep = GetIt.I<ChatHistoryStateRep>();

  ChatSessionBloc() : super(const ChatSessionInitial()){
    on<InitRetrieveSession>(_initRetrieveChatSession);
    on<RetrieveChatSession>(_retrieveChatSession);
    // on<ChooseSession>(_chooseSession);
    on<NewSessionCreated>(_onNewSessionCreated);
  }

  void _initRetrieveChatSession(InitRetrieveSession event, Emitter<ChatSessionState> emit) async {
    emit(const ChatSessionLoading());
    // 立刻先从数据库中获取数据
    Result<List<ChatSession>> result = await _chatRep.getDefaultRecentChats(
        num: FeatureConst.defHistoryChatSessionNum,
        userId: TestData.testUserId,
    );
    int nowIndex=0;
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const ChatSessionFailure());
    } else {
      _stateRep.setSessions(result.data!);
      for(int i=0;i<_stateRep.sessions.length;++i){
        if(_stateRep.sessions[i].sessionId==event.nowSessionId){
          nowIndex=i;
          break;
        }
      }
      emit(ChatSessionSuccess(
        nowIndex: nowIndex,
        len: _stateRep.sessions.length,
        changeFrom: SessionChangeFrom.Local,
      ));
    }
    // 开始从网络获取最新数据
    result = await _chatRep.getRecentChatsOnlyNet(
        offset: 0,
        num: FeatureConst.defHistoryChatSessionNum,
        userId: TestData.testUserId,
    );
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const ChatSessionFailure());
    } else {
      _stateRep.setSessions(result.data!);
      for(int i=0;i<_stateRep.sessions.length;++i){
        if(_stateRep.sessions[i].sessionId==event.nowSessionId){
          nowIndex=i;
          break;
        }
      }
      emit(ChatSessionSuccess(
        nowIndex: nowIndex,
        len: _stateRep.sessions.length,
        changeFrom: SessionChangeFrom.Net,
      ));
    }
  }
  void _retrieveChatSession(RetrieveChatSession event, Emitter<ChatSessionState> emit) async {
    emit(const ChatSessionLoading());
    Result<List<ChatSession>> result = await _chatRep.getRecentChatsOnlyNet(
        offset: _stateRep.sessions.length,
        num: FeatureConst.defHistoryChatSessionPage,
        userId: TestData.testUserId,
    );
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const ChatSessionFailure());
    } else {
      _stateRep.addSessions(result.data!);
      emit(ChatSessionSuccess(
        nowIndex: _stateRep.nowIndex,
        len: _stateRep.sessions.length,
        changeFrom: SessionChangeFrom.Net,
      ));
    }
  }
  // void _chooseSession(ChooseSes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              s;;;;;ion event, Emitter<ChatSessionState> emit) async {
  //   _historyStateRep.setNowSession(event.chosenSession);
  // }
  void _onNewSessionCreated(NewSessionCreated event, Emitter<ChatSessionState> emit) async {
    _stateRep.sessions.insert(0, event.newSession);
    // 保存到数据库
    _chatRep.saveSession(event.newSession);
    emit(ChatSessionSuccess(
      nowIndex: 0,
      len: _stateRep.sessions.length,
      changeFrom: SessionChangeFrom.UserNow,
    ));
  }
}