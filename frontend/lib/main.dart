import 'package:flutter/material.dart';
import 'core/config/theme.dart';
import 'core/config/app_routes.dart';

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
      theme: appTheme, 
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.generateRoute, 
    );
  }
}
