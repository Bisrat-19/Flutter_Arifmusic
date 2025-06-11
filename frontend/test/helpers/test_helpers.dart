import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

class TestHelpers {
  static Widget createTestApp({
    Widget? home,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: home ?? const Scaffold(),
        theme: ThemeData.dark(),
      ),
    );
  }

  static UserModel createTestUser({
    String id = '123',
    String fullName = 'Test User',
    String email = 'test@example.com',
    String role = 'listener',
    String token = 'test_token',
    String? profileImage,
  }) {
    return UserModel(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      token: token,
      profileImage: profileImage,
    );
  }

  static Map<String, dynamic> createTestSong({
    String id = '1',
    String title = 'Test Song',
    String genre = 'Pop',
    String artistName = 'Test Artist',
    String audioPath = '/test.mp3',
    String? coverImagePath,
    int playCount = 0,
  }) {
    return {
      '_id': id,
      'title': title,
      'genre': genre,
      'artistName': artistName,
      'audioPath': audioPath,
      'coverImagePath': coverImagePath,
      'playCount': playCount,
    };
  }

  static Future<void> enterTextAndSettle(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  static Finder findTextFormFieldByHint(String hintText) {
    return find.widgetWithText(TextFormField, hintText);
  }

  static Finder findButtonByText(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }
}

class MockUserNotifier extends UserNotifier {
  final UserModel? mockUser;
  final bool mockIsLoading;
  final String? mockError;

  MockUserNotifier({
    this.mockUser,
    this.mockIsLoading = false,
    this.mockError,
  });

  @override
  UserState build() {
    return UserState(
      user: mockUser,
      token: mockUser?.token,
      role: mockUser?.role,
      isLoading: mockIsLoading,
      error: mockError,
    );
  }
}
