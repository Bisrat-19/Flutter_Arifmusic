import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/theme.dart';
import 'core/config/app_routes.dart';

// Providers
import 'presentation/providers/user_provider.dart';

// Repositories and dependencies
import 'data/datasources/local_storage_service.dart';
import 'data/datasources/user_remote_data_source_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArifMusicApp());
}

class ArifMusicApp extends StatelessWidget {
  const ArifMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide UserRepository so it can be injected anywhere
        Provider<UserRepository>(
          create: (_) => UserRepositoryImpl(
            remoteDataSource: UserRemoteDataSourceImpl(),
            localStorageService: LocalStorageService(),
          ),
        ),

        // Provide UserProvider (ChangeNotifier) that uses the repository
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'ArifMusic',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
