import 'package:flutter/material.dart';

import '../screens/splash/splash.dart';
import '../screens/home/home.dart';
import '../screens/onboarding/onboarding.dart';
import '../screens/signup/signup.dart';
import '../screens/profile/profile.dart';
import '../screens/login/login.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/splash': (context) => SplashScreen(),
      '/home': (context) => HomeScreen(),
      '/onboarding': (context) => OnboardingScreen(),
      '/signup': (context) => SignupScreen(),
      '/profile': (context) => ProfileScreen(),
      '/login': (context) => LoginScreen(),
    };
  }
}
