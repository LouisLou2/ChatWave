import 'package:chat_wave/feature/chat/bloc/chat_session_bloc.dart';
import 'package:chat_wave/respository/interface/chat_rep.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../constant/feature_const.dart';
import '../../../constant/test_data.dart';
import '../../../domain/entity/chat_session.dart';
import '../../../domain/util_model/res_info.dart';
import '../../../ui/helper/toast_helper.dart';
/*-----------------event----------------------*/
sealed class HomePageLoadEvent {
  const HomePageLoadEvent();
}

class StartLoadHomePage extends HomePageLoadEvent {
  const StartLoadHomePage();
}

class RetrieveRecentChats extends HomePageLoadEvent {
  const RetrieveRecentChats();
}
/*-----------------state----------------------*/
sealed class HomePageLoadState extends Equatable {
  const HomePageLoadState();
}

class HomePageLoadInitial extends HomePageLoadState {
  const HomePageLoadInitial();
  @override
  List<Object?> get props => [];
}

class HomePageLoadInProgress extends HomePageLoadState {
  const HomePageLoadInProgress();
  @override
  List<Object?> get props => [];
}

class HomePageLoadSuccess extends HomePageLoadState {
  final int len;
  final SessionChangeFrom changeFrom;
  const HomePageLoadSuccess({required this.len, required this.changeFrom});
  @override
  List<Object?> get props => [len,changeFrom];
}

class HomePageLoadFailure extends HomePageLoadState {

  const HomePageLoadFailure();
  @override
  List<Object?> get props => [];
}
/*----------------------state_repository--------------------------*/
class HomePageStateRep {
  List<ChatSession> recentChats = [];
  void setRecentChats(List<ChatSession> chats) {
    recentChats = chats;
  }
  void addRecentChats(List<ChatSession> chats) {
    recentChats.addAll(chats);
  }
}

/*-------------------------------bloc--------------------------------*/
class HomePageLoadBloc extends Bloc<HomePageLoadEvent, HomePageLoadState> {

  final ChatRep _chatRep = GetIt.I<ChatRep>();
  final HomePageStateRep _homeStateRep = GetIt.I<HomePageStateRep>();

  HomePageLoadBloc() : super(const HomePageLoadInitial()) {
    on<StartLoadHomePage>(_startLoadHomePage);
    on<RetrieveRecentChats>(_retrieveRecentChats);
  }
  /*-------------handle all the event-------------*/
  void _startLoadHomePage(StartLoadHomePage event, Emitter<HomePageLoadState> emit) async{
    emit(const HomePageLoadInProgress());
    // 去获取数据,先是数据库
    // 立刻先从数据库中获取数据
    Result<List<ChatSession>> result = await _chatRep.getDefaultRecentChats(
      num: FeatureConst.defHistoryChatSessionNum,
      userId: TestData.testUserId,
    );
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const HomePageLoadFailure());
    } else {
      _homeStateRep.setRecentChats(result.data!);
      emit(
        HomePageLoadSuccess(
          len: _homeStateRep.recentChats.length,
          changeFrom: SessionChangeFrom.Local,
        ),
      );
    }
    // 开始从网络获取最新数据
    result = await _chatRep.getRecentChatsOnlyNet(
      offset: 0,
      num: FeatureConst.defHistoryChatSessionNum,
      userId: TestData.testUserId,
    );
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const HomePageLoadFailure());
    } else {
      _homeStateRep.setRecentChats(result.data!);
      emit(
        HomePageLoadSuccess(
          len: _homeStateRep.recentChats.length,
          changeFrom: SessionChangeFrom.Net,
        ),
      );
    }
  }

  void _retrieveRecentChats(RetrieveRecentChats event, Emitter<HomePageLoadState> emit)async {
    emit(const HomePageLoadInProgress());
    Result<List<ChatSession>> result = await _chatRep.getRecentChatsOnlyNet(
      offset: _homeStateRep.recentChats.length,
      num: FeatureConst.defHistoryChatSessionPage,
      userId: TestData.testUserId,
    );
    if(!result.isSuccess) {
      ToastHelper.showToasterWithRescode(result.resCode);// 几乎不可能失败
      emit(const HomePageLoadFailure());
    } else {
      _homeStateRep.addRecentChats(result.data!);
      emit(
        HomePageLoadSuccess(
          len: _homeStateRep.recentChats.length,
          changeFrom: SessionChangeFrom.Net,
        ),
      );
    }
  }
}
