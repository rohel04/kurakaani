import 'package:flutter/material.dart';
import 'package:kurakaani/pages/complete_profile.dart';
import 'package:kurakaani/pages/home_page.dart';
import 'package:kurakaani/pages/login_page.dart';
import 'package:kurakaani/pages/register_page.dart';
import 'package:kurakaani/pages/splash_screen.dart';

class Routers {
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';
  static const loginScreen = '/loginScreen';
  static const registerScreen = '/registerScreen';
  static const completeProfileScreen = '/completeProfile/Screen';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_)=>const SplashScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case completeProfileScreen:
        return MaterialPageRoute(builder: (_) => const CompleteProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
