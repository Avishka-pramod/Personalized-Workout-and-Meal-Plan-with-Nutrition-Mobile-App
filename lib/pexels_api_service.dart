import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsApiService {
  final String _apiKey = 'YOUR_PEXELS_API_KEY';  // Replace with your actual API key
  final String _baseUrl = 'https://api.pexels.com/videos/search';

  // Function to fetch workout video based on workout title
  Future<String?> fetchWorkoutVideo(String workoutTitle) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=$workoutTitle&per_page=1'),
      headers: {
        'Authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['videos'].isNotEmpty) {
        return jsonResponse['videos'][0]['video_files'][0]['link'];  // Return the first video URL
      }
      return null;
    } else {
      throw Exception('Failed to load video');
    }
  }

  fetchInjuryPreventionVideo(String workout) {}
}
