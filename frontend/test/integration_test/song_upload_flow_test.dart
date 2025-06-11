import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/artist/artist_dashboard_screen.dart';
import 'package:frontend/services/song_service.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class MockSongService extends Mock implements SongService {}
class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockSongService mockSongService;
  late MockUserProvider mockUserProvider;
  late PlatformFile mockAudioFile;

  setUp(() {
    mockSongService = MockSongService();
    mockUserProvider = MockUserProvider();
    mockAudioFile = PlatformFile(
      name: 'test.mp3',
      size: 1024,
      bytes: null,
      path: 'test.mp3'
    );
  });

  group('Song Upload Flow', () {
    testWidgets('User can fill song details and upload', (WidgetTester tester) async {
      // Setup mock response
      final mockUser = UserModel(
        id: '1',
        fullName: 'Test Artist',
        email: 'test@example.com',
        role: 'artist'
      );

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
      when(mockUserProvider.user).thenReturn(mockUser);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<SongService>.value(value: mockSongService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: ArtistDashboardScreen(),
          ),
        ),
      );

      // Navigate to upload section
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in song details
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Song');
      await tester.enterText(find.byType(TextFormField).at(1), 'Pop');
      await tester.enterText(find.byType(TextFormField).at(2), 'Test Description');

      // Tap upload button
      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();

      // Verify upload was called with correct data
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

    testWidgets('Shows error message on upload failure', (WidgetTester tester) async {
      // Setup mock to throw error
      final mockUser = UserModel(
        id: '1',
        fullName: 'Test Artist',
        email: 'test@example.com',
        role: 'artist'
      );

      when(mockSongService.uploadSong(
        'test_token',
        token: 'test_token',
        title: 'Test Song',
        genre: 'Pop',
        description: 'Test Description',
        artistId: '1',
        audioFile: mockAudioFile,
      )).thenThrow(Exception('Upload failed'));

      when(mockUserProvider.token).thenReturn('test_token');
      when(mockUserProvider.user).thenReturn(mockUser);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<SongService>.value(value: mockSongService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: ArtistDashboardScreen(),
          ),
        ),
      );

      // Navigate to upload section
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in song details
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Song');
      await tester.enterText(find.byType(TextFormField).at(1), 'Pop');
      await tester.enterText(find.byType(TextFormField).at(2), 'Test Description');

      // Tap upload button
      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Upload failed'), findsOneWidget);
    });

    testWidgets('Validates required fields', (WidgetTester tester) async {
      final mockUser = UserModel(
        id: '1',
        fullName: 'Test Artist',
        email: 'test@example.com',
        role: 'artist'
      );

      when(mockUserProvider.token).thenReturn('test_token');
      when(mockUserProvider.user).thenReturn(mockUser);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<SongService>.value(value: mockSongService),
            ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          ],
          child: MaterialApp(
            home: ArtistDashboardScreen(),
          ),
        ),
      );

      // Navigate to upload section
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Try to upload without filling required fields
      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();

      // Verify validation messages
      expect(find.text('Please enter song title'), findsOneWidget);
      expect(find.text('Please enter genre'), findsOneWidget);
      expect(find.text('Please enter description'), findsOneWidget);

      // Verify upload was not called
      verifyNever(mockSongService.uploadSong(
        'test_token',
        token: 'test_token',
        title: '',
        genre: '',
        description: '',
        artistId: '1',
        audioFile: mockAudioFile,
      ));
    });
  });
} 