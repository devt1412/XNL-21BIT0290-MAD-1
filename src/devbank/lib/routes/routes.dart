import 'package:flutter/material.dart';

import '../features/splash/splash.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/splash': (context) => const SplashScreen(),
    };
  }
}
