import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NutritionVideosScreen extends StatefulWidget {
  final String recipeName;  // Pass the recipe name to search for videos

  NutritionVideosScreen({required this.recipeName});

  @override
  _NutritionVideosScreenState createState() => _NutritionVideosScreenState();
}

class _NutritionVideosScreenState extends State<NutritionVideosScreen> {
  bool _isLoading = true;
  List<dynamic> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchYouTubeVideos();  // Fetch videos when the screen is opened
  }

  Future<void> _fetchYouTubeVideos() async {
    final String apiKey = 'YOUR_YOUTUBE_API_KEY';  // Replace with your API key
    final String query = widget.recipeName + ' recipe';
    final Uri apiUrl = Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&q=$query&key=$apiKey');

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _videos = data['items'];
          _isLoading = false;
        });
      } else {
        print('Failed to load videos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Videos: ${widget.recipeName}'),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videos.isEmpty
              ? const Center(child: Text('No videos found.'))
              : ListView.builder(
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    final videoTitle = video['snippet']['title'];
                    final videoId = video['id']['videoId'];
                    final videoThumbnail = video['snippet']['thumbnails']['default']['url'];

                    return InkWell(
                      onTap: () {
                        _launchVideo(videoId);  // Open video when tapped
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(videoThumbnail),
                          title: Text(videoTitle),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _launchVideo(String videoId) async {
    final Uri videoUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(videoUrl)) {
      await launchUrl(videoUrl);
    } else {
      print('Could not launch video');
    }
  }
}
