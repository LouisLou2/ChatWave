import 'package:chat_wave/feature/chat/view/chat_page.dart';
import 'package:flutter/cupertino.dart';

import '../feature/main/view/home_page.dart';
import '../feature/main/view/onboarding_page.dart';

class RouteCollector {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String chat = '/chat';

  static const Set<String> simpleRoutes = {
    onboarding,
    home,
    chat,
  };

  // specialRoutes中的路由不会在路由表中注册，而是在RouteGenerator中动态生成,因为这些路由需要用户满足某种条件才能跳转
  static const Set<String> specialRoutes = {

  };
  static Map<String, WidgetBuilder> simpleRouteMap = {
    onboarding: (context) => const OnBoardingPage(),
    home: (context) => const HomePage(),
    chat: (context) => const ChatPage(),
  };
}