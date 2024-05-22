// import 'package:chat_wave/usecase/path_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get_it/get_it.dart';
// import 'config/test_device.dart';
// import 'datasource/db/manage/db_manager.dart';
// import 'datasource/network/manage/network_config.dart';
// import 'datasource/ws/websocket_manager.dart';
//
import 'package:chat_wave/datasource/network/interface/chat_net_ds.dart';
import 'package:chat_wave/feature/chat/bloc/chat_history_bloc.dart';
import 'package:chat_wave/feature/main/bloc/auth_bloc.dart';
import 'package:chat_wave/feature/main/bloc/homepage_load_bloc.dart';
import 'package:chat_wave/feature/main/bloc/theme_bloc.dart';
import 'package:chat_wave/respository/implement/chat_resp_impl.dart';
import 'package:chat_wave/respository/interface/chat_rep.dart';
import 'package:chat_wave/usecase/path_manager.dart';
import 'package:chat_wave/usecase/requester/implement/chat_requester_imple.dart';
import 'package:chat_wave/usecase/requester/interface/chat_requester.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

import 'datasource/db/implement/chat_db_ds_impl.dart';
import 'datasource/db/interface/chat_db_ds.dart';
import 'datasource/db/manage/db_manager.dart';
import 'datasource/network/implement/chat_net_ds_impl.dart';
import 'datasource/network/manage/network_config.dart';
import 'feature/chat/bloc/chat_session_bloc.dart';
import 'feature/chat/bloc/chating_action_bloc.dart';
import 'feature/chat/repository/chat_history_rep.dart';

Future<void> initMustBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PathManager.init();// 初始化路径，前置依赖: WidgetsFlutterBinding.ensureInitialized();
  await DBManager.init();// 初始化数据库，前置依赖: PathManager
  await initInjection();// 初始化依赖注入，有一部分依赖前置: DBManager，networkManager
}


void initWhenWidgetBuilding(BuildContext context){
  final Brightness brightness = MediaQuery.platformBrightnessOf(context);
  GetIt.I<ThemeBloc>().add(brightness == Brightness.light ? const ToLightTheme() : const ToDarkTheme());
  generalUIInit(brightness);
}

Future<void> initAsync() async {
  NetworkConfig.init();// 初始化网络配置，前置依赖: ProvManager.init();
  //wsInit();// 初始化WebSocket，前置依赖: ProvManager.initUserState
}

void generalUIInit(Brightness b){
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: b,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: b==Brightness.light?Brightness.dark:Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  EasyLoading.instance.indicatorType=EasyLoadingIndicatorType.fadingCircle;
}


// // lazy and not lazy
Future<void> initInjection() async {
  /*------------------datasource_net-----------------------------*/
  GetIt.I.registerLazySingleton<ChatNetDs>(() => ChatNetDsImpl());
  /*------------------datasource_net-----------------------------*/
  GetIt.I.registerLazySingleton<ChatDbDs>(() => ChatDbDsImpl());
  /*------------------repository-------------------*/
  GetIt.I.registerLazySingleton<ChatRep>(() => ChatRepImpl());
  /*------------------stateRep---------------------*/
  GetIt.I.registerLazySingleton<HomePageStateRep>(() => HomePageStateRep());
  GetIt.I.registerLazySingleton<ChatHistoryStateRep>(() => ChatHistoryStateRep());
  GetIt.I.registerLazySingleton<ChatSessionStateRep>(() => ChatSessionStateRep());
  /*------------------bloc--------------------------*/
  GetIt.I.registerLazySingleton<ThemeBloc>(() => ThemeBloc(const LightThemeState()));
  GetIt.I.registerLazySingleton<AuthBloc>(() => AuthBloc(const NotLoggedInState()));
  GetIt.I.registerLazySingleton<HomePageLoadBloc>(() => HomePageLoadBloc());

  GetIt.I.registerLazySingleton<ChatSessionBloc>(() => ChatSessionBloc());
  GetIt.I.registerLazySingleton<ChatHistoryBloc>(() => ChatHistoryBloc());
  GetIt.I.registerLazySingleton<ChatActionBloc>(() => ChatActionBloc());
  /*------------------requester---------------------*/
  GetIt.I.registerLazySingleton<ChatRequester>(() => ChatRequesterImple());
}
//
// Future<void> wsInit() async {
//   if(!ProvManager.userProv.isLogin)return;
//   WebSocketManager.initInstance(
//     token: ProvManager.userProv.token,
//     onMessage: (message){
//       GetIt.I<ChatMessenger>().receiveMessage(message);
//     },
//   );
// }

