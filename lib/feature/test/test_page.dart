import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation1;
  late final Animation<Offset> _offsetAnimation2;
  late final Animation<Offset> _offsetAnimation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 定义三个偏移动画，每个动画稍有延迟
    _offsetAnimation1 = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // 从屏幕外的右边开始
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _offsetAnimation2 = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // 从屏幕外的右边开始
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2, 1.0,
        curve: Curves.easeInOut,
      ),
    ));

    _offsetAnimation3 = Tween<Offset>(
      begin: const Offset(3, 0.0), // 从屏幕外的右边开始
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.4, 1.0,
        curve: Curves.easeInOut,
      ),
    ));

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide In Row Example'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation1,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
                margin: EdgeInsets.all(8),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation2,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.green,
                margin: EdgeInsets.all(8),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation3,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
                margin: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}