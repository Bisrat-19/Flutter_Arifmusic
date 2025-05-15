import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
    routes: {
      '/login': (_) => LoginScreen(),
      '/register': (_) => RegisterScreen(),
      '/home': (_) => Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Center(child: Text("Welcome to ArifMusic!")),
          ),
    },
  ));
}
