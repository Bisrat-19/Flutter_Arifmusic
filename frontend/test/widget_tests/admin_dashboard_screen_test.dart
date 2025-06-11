import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/admin/admin_dashboard_screen.dart';
import 'package:frontend/services/admin_service.dart';
import 'package:frontend/providers/user_provider.dart';

class MockAdminService extends Mock implements AdminService {
  fetchUsers() {}
}
class MockUserProvider extends Mock implements UserProvider {}

void main() {
  testWidgets('AdminDashboardScreen renders with mocked services', (WidgetTester tester) async {
    final mockAdminService = MockAdminService();
    final mockUserProvider = MockUserProvider();
    // Setup mock behavior as needed
    when(mockUserProvider.role).thenReturn('admin');
    when(mockUserProvider.token).thenReturn('mock-token');
    // Add more mock setups as needed

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdminService>.value(value: mockAdminService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    expect(find.byType(AdminDashboardScreen), findsOneWidget);
    // Add more expectations as needed
  });

  testWidgets('AdminDashboardScreen shows error when user fetch fails', (WidgetTester tester) async {
    final mockAdminService = MockAdminService();
    final mockUserProvider = MockUserProvider();

    // Simulate an error when fetching users
    when(mockAdminService.fetchUsers()).thenThrow(Exception('Failed to fetch users'));
    when(mockUserProvider.role).thenReturn('admin');
    when(mockUserProvider.token).thenReturn('mock-token');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdminService>.value(value: mockAdminService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    // You may need to pump again if your widget uses FutureBuilder/StreamBuilder
    await tester.pumpAndSettle();

    // Check for error message in the UI
    expect(find.textContaining('Failed to fetch users'), findsOneWidget);
  });

  testWidgets('AdminDashboardScreen allows deleting a user', (WidgetTester tester) async {
    final mockAdminService = MockAdminService();
    final mockUserProvider = MockUserProvider();

    // Simulate a list of users
    when(mockAdminService.fetchUsers()).thenAnswer((_) async => [
      {'id': '1', 'name': 'Test User'}
    ]);
    when(mockAdminService.deleteUser('mock-token', '1')).thenAnswer((_) async => true);
    when(mockUserProvider.role).thenReturn('admin');
    when(mockUserProvider.token).thenReturn('mock-token');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdminService>.value(value: mockAdminService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the delete button (update the finder as per your widget)
    final deleteButton = find.byIcon(Icons.delete).first;
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Optionally, check that deleteUser was called
    verify(mockAdminService.deleteUser('mock-token', '1')).called(1);
  });

  // Add more tests for user/song management, error states, and actions as needed
} 