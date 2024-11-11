import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _baseUrl = 'www.googleapis.com';
  static const String _apiKey = 'AIzaSyCmNbd6oZ5OUhGj1w8q4rD0iBYp2_XBHuc'; // Replace with your actual API key

  Future<List<dynamic>> fetchWorkoutVideos(String query) async {
    final uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': '10',
        'key': _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }
}
