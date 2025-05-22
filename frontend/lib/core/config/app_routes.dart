import 'package:flutter/material.dart';

import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/welcome/welcome_screen.dart';
import '../../presentation/common/main_navigation.dart';
import '../../presentation/artist/artist_dashboard_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNav = '/main';
  static const String artistDashboard = '/artist-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case mainNav:
        final tab = settings.arguments is int && (settings.arguments as int) >= 0 && (settings.arguments as int) <= 3
            ? settings.arguments as int
            : 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigation(initialIndex: tab),
        );

      case artistDashboard:
        return MaterialPageRoute(builder: (_) => const ArtistDashboardScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
