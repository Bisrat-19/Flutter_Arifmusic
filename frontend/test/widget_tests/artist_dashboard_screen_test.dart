import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/artist/artist_dashboard_screen.dart';
import 'package:frontend/services/song_service.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:file_picker/file_picker.dart';

class MockSongService extends Mock implements SongService {
  pickAudioFile() {}
}
class MockUserProvider extends Mock implements UserProvider {}

void main() {
  testWidgets('ArtistDashboardScreen renders with mocked services', (WidgetTester tester) async {
    final mockSongService = MockSongService();
    final mockUserProvider = MockUserProvider();
    // Setup mock behavior as needed
    when(mockUserProvider.user).thenReturn(null); // or provide a mock user if needed
    // Add more mock setups as needed

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SongService>.value(value: mockSongService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: ArtistDashboardScreen()),
      ),
    );

    expect(find.byType(ArtistDashboardScreen), findsOneWidget);
    // Add more expectations as needed
  });

  testWidgets('ArtistDashboardScreen shows validation error for empty form', (WidgetTester tester) async {
    final mockSongService = MockSongService();
    final mockUserProvider = MockUserProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SongService>.value(value: mockSongService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: ArtistDashboardScreen()),
      ),
    );

    // Try to submit the form without filling fields
    final submitButton = find.text('Upload'); // Adjust if your button text is different
    expect(submitButton, findsOneWidget);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Check for validation error message
    expect(find.textContaining('required'), findsWidgets); // Adjust to your actual error message
  });

  testWidgets('ArtistDashboardScreen shows error when file picking fails', (WidgetTester tester) async {
    final mockSongService = MockSongService();
    final mockUserProvider = MockUserProvider();

    // Simulate file picking error
    when(mockSongService.pickAudioFile()).thenThrow(Exception('File pick failed'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SongService>.value(value: mockSongService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: ArtistDashboardScreen()),
      ),
    );

    // Tap the file picker button (adjust the finder as per your widget)
    final filePickerButton = find.byIcon(Icons.attach_file);
    expect(filePickerButton, findsOneWidget);
    await tester.tap(filePickerButton);
    await tester.pumpAndSettle();

    // Check for error message in the UI
    expect(find.textContaining('File pick failed'), findsOneWidget);
  });

  testWidgets('ArtistDashboardScreen calls uploadSong on valid form', (WidgetTester tester) async {
    final mockSongService = MockSongService();
    final mockUserProvider = MockUserProvider();
    final mockAudioFile = PlatformFile(
      name: 'test.mp3',
      size: 1024,
      bytes: null,
      path: 'test.mp3'
    );

    // Simulate successful upload
    when(mockSongService.uploadSong(
      'test_token',
      token: 'test_token',
      title: 'Test Song',
      genre: 'Pop',
      description: 'Test Description',
      artistId: '1',
      audioFile: mockAudioFile,
    )).thenAnswer((_) async => {
      'success': true,
      'message': 'Track uploaded successfully'
    });

    when(mockUserProvider.token).thenReturn('test_token');
    when(mockUserProvider.user).thenReturn(UserModel(
      id: '1',
      fullName: 'Test Artist',
      email: 'test@example.com',
      role: 'artist'
    ));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SongService>.value(value: mockSongService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: ArtistDashboardScreen()),
      ),
    );

    // Fill the form fields (adjust the finders as per your widget)
    await tester.enterText(find.byType(TextFormField).first, 'Test Song');
    await tester.enterText(find.byType(TextFormField).at(1), 'Pop');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test Description');

    // Tap the upload button
    final uploadButton = find.text('Upload'); // Adjust if your button text is different
    expect(uploadButton, findsOneWidget);
    await tester.tap(uploadButton);
    await tester.pumpAndSettle();

    // Verify that uploadSong was called with correct parameters
    verify(mockSongService.uploadSong(
      'test_token',
      token: 'test_token',
      title: 'Test Song',
      genre: 'Pop',
      description: 'Test Description',
      artistId: '1',
      audioFile: mockAudioFile,
    )).called(1);
  });
} 