import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockAuthService mockAuthService;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserProvider = MockUserProvider();
  });

  group('Login Integration Test', () {
    testWidgets('User can enter email and password and tap login', (WidgetTester tester) async {
      // Setup mock response
      final mockUserData = {
        '_id': '1',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': 'listener'
      };

      when(mockAuthService.login('test@example.com', 'password123')).thenAnswer((_) async => {
        'success': true,
        'token': 'test_token',
        'user': mockUserData
      });

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter email
      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      // Enter password
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify login was called with correct credentials
      verify(mockAuthService.login('test@example.com', 'password123')).called(1);
      verify(mockUserProvider.setUser('test_token', mockUserData)).called(1);
    });

    testWidgets('Shows error message on invalid credentials', (WidgetTester tester) async {
      // Setup mock to throw error
      when(mockAuthService.login('wrong@example.com', 'wrongpass'))
          .thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter credentials
      await tester.enterText(find.byType(TextFormField).at(0), 'wrong@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('Validates required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Try to login without entering credentials
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify validation messages
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // Verify login was not called
      verifyNever(mockAuthService.login('', ''));
    });
  });
} 