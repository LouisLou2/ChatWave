import 'package:flutter/material.dart';

class MyObserver extends NavigatorObserver {
  final List<String> pages = [];

  @override
  void didPush(Route route, Route? previousRoute) {
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // i don't know what to do
  }

  @override
  void didPop(Route route, Route? previousRoute) {

  }
}