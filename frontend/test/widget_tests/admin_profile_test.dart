import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../lib/screens/profile/admin_profile.dart';
import '../../lib/providers/user_provider.dart';

class MockUserProvider extends Mock implements UserProvider {}

void main() {
  testWidgets('AdminProfile renders with mocked UserProvider', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();
    // Setup mock behavior as needed
    when(mockUserProvider.user).thenReturn(null); // or provide a mock user if needed
    // Add more mock setups as needed

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: const MaterialApp(home: AdminProfile()),
      ),
    );

    expect(find.byType(AdminProfile), findsOneWidget);
    // Add more expectations as needed
  });

  testWidgets('AdminProfile shows error when image picking fails', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();
    // Simulate an error state for image picking
    when(mockUserProvider.user).thenReturn(null);
    when(mockUserProvider.pickProfileImage()).thenThrow(Exception('Image pick failed'));

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: const MaterialApp(home: AdminProfile()),
      ),
    );

    // Simulate tapping the image picker button (update the finder as per your widget)
    final imagePickerButton = find.byIcon(Icons.camera_alt);
    expect(imagePickerButton, findsOneWidget);
    await tester.tap(imagePickerButton);
    await tester.pumpAndSettle();

    // Check for error message in the UI
    expect(find.textContaining('Image pick failed'), findsOneWidget);
  });

  testWidgets('AdminProfile logout button calls logout', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();
    when(mockUserProvider.user).thenReturn(null);

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: const MaterialApp(home: AdminProfile()),
      ),
    );

    // Simulate tapping the logout button (update the finder as per your widget)
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Optionally, check that logout was called
    verify(mockUserProvider.logout()).called(1);
  });

  // Add more tests for image picking, button actions, and error states as needed
} 