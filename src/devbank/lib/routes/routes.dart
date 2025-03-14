import 'package:flutter/material.dart';

import '../screens/splash/splash.dart';
import '../screens/home/home.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/splash': (context) => SplashScreen(),
      '/home': (context) => HomeScreen(),
    };
  }
}
