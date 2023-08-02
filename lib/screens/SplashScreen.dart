import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _imageIndex = 0;
  List<String> _images = [
    'assets/images/splash1.png',
    'assets/images/splash2.png',
    'assets/images/splash3.png'
  ];

  void _startTimer() {
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Image.asset(
            _images[_imageIndex],
            key: ValueKey<int>(_imageIndex),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              child: child,
              opacity: animation,
            );
          },
        ),
      ),
    );
  }
}