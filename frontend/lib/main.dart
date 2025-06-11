import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/theme.dart';
import 'core/config/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ArifMusicApp(),
    ),
  );
}

class ArifMusicApp extends ConsumerWidget {
  const ArifMusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'ArifMusic',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: AppRoutes.router,
    );
  }
}