import 'dart:ui';
import 'package:chat_wave/config/test_device.dart';
import 'package:chat_wave/feature/main/bloc/theme_bloc.dart';
import 'package:chat_wave/feature/main/view/home_page.dart';
import 'package:chat_wave/feature/main/view/onboarding_page.dart';
import 'package:chat_wave/feature/test/test_page.dart';
import 'package:chat_wave/init_affairs.dart';
import 'package:chat_wave/router/navigation_helper.dart';
import 'package:chat_wave/router/route_collector.dart';
import 'package:chat_wave/router/route_generator.dart';
import 'package:chat_wave/style/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../chat/bloc/chat_history_bloc.dart';
import '../chat/bloc/chat_session_bloc.dart';
import '../chat/bloc/chating_action_bloc.dart';
import '../chat/repository/chat_history_rep.dart';
import '../chat/view/chat_page.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/homepage_load_bloc.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  void initState(){
    super.initState();
    var dispatcher = PlatformDispatcher.instance;
    dispatcher.onPlatformBrightnessChanged = () {
      //TODO: 1.根据亮度切换主题
    };
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    initWhenWidgetBuilding(context);

    return ScreenUtilInit(
      designSize: TestDeviceCollection.mobile.size,
      child: ToastificationWrapper(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: GetIt.I<ThemeBloc>(),),
            BlocProvider<AuthBloc>.value(value: GetIt.I<AuthBloc>(),),
            BlocProvider<HomePageLoadBloc>.value(value: GetIt.I<HomePageLoadBloc>(),),
            BlocProvider<ChatSessionBloc>.value(value: GetIt.I<ChatSessionBloc>(),),
            BlocProvider<ChatActionBloc>.value(value: GetIt.I<ChatActionBloc>(),),
            BlocProvider<ChatHistoryBloc>.value(value: GetIt.I<ChatHistoryBloc>(),),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<HomePageStateRep>.value(value: GetIt.I<HomePageStateRep>(),),
              RepositoryProvider<ChatSessionStateRep>.value(value: GetIt.I<ChatSessionStateRep>(),),
              RepositoryProvider<ChatHistoryStateRep>.value(value: GetIt.I<ChatHistoryStateRep>(),),
            ],
            child:  BlocBuilder<ThemeBloc, ThemeState>(
              builder: (BuildContext context, ThemeState state) {
                return MaterialApp(
                    title: 'Chat Wave',
                    theme: ThemeCollection.light,
                    darkTheme: ThemeCollection.dark,
                    themeMode: state.mode,
                    navigatorKey: NavigationHelper.key,
                    onGenerateRoute: RouteGenerator.generateRoute,
                    builder: EasyLoading.init(),
                    routes: RouteCollector.simpleRouteMap,
                    home: BlocBuilder<AuthBloc, AuthState>(
                      builder: (BuildContext context, AuthState state) {
                        if(state is CheckingAuthState){
                          return const Center(
                            child:CircularProgressIndicator(),
                          );
                        }else if(state is LoggedInState){
                          return const HomePage(); // 进入主界面
                        }else if(state is NotLoggedInState){
                          return const OnBoardingPage(); // 进入欢迎页面
                        }
                        // error
                        return const Center(
                          child: Text('Error'),
                        );
                      },
                    )
                );
              },
            ),
          )
        ),
      ),
    );
  }

  Widget _getHome(){
    return Container();
  }
}