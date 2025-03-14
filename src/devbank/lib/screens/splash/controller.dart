import 'dart:async';
import 'package:flutter/material.dart';

class SplashController {
  void startSplashTimer(BuildContext context) {
    Timer(Duration(seconds: 4), () async {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    });
  }
}
