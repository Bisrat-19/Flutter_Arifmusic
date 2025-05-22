import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/config/constants.dart';  // For baseUrl

class SongService {
  final Dio _dio;

  SongService([Dio? dio]) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> uploadSong({
    required String token,
    required String title,
    required String genre,
    required String description,
    required String artistId,
    required File audioFile,
    File? coverImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'genre': genre,
        'description': description,
        'artistId': artistId,
        'audio': await MultipartFile.fromFile(audioFile.path, filename: audioFile.path.split('/').last),
        if (coverImage != null)
          'coverImage': await MultipartFile.fromFile(coverImage.path, filename: coverImage.path.split('/').last),
      });

      final response = await _dio.post(
        '$baseUrl/api/songs/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Track uploaded successfully'};
      } else {
        return {'success': false, 'message': 'Failed to upload track: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error uploading track: $e'};
    }
  }
}
