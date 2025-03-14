import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController {
  void startSplashTimer(BuildContext context) {
    Timer(Duration(seconds: 4), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
          (Route<dynamic> route) => false,
        );
      }
    });
  }
}
