import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/common/main_navigation.dart';

class AppRoutes {
  static const String welcome  = '/';
  static const String login    = '/login';
  static const String register = '/register';

  // SINGLE entry‑point for all bottom‑nav tabs
  static const String mainNav  = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // Always land inside MainNavigation and
      // pass the tab index via `arguments`
      case mainNav:
        final int tab = settings.arguments as int? ??
            0; // 0‑home | 1‑search | 2‑library | 3‑profile
        return MaterialPageRoute(
          builder: (_) => MainNavigation(initialIndex: tab),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
