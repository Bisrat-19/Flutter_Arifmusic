import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/common/home_screen.dart'; // Replace with actual HomeScreen
import 'config/theme.dart'; // Optional: your custom theme config

void main() {
  runApp(const ArifMusicApp());
}

class ArifMusicApp extends StatelessWidget {
  const ArifMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArifMusic',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // Optional: Use your dark/light theme
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(), // Replace placeholder
      },
    );
  }
}
