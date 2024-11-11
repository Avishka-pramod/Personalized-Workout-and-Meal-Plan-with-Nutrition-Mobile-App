import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'youtube_service.dart';

class WorkVideosScreen extends StatefulWidget {
  final String searchQuery;

  // Constructor to accept the search query (workout title)
  WorkVideosScreen({required this.searchQuery});

  @override
  _WorkVideosScreenState createState() => _WorkVideosScreenState();
}

class _WorkVideosScreenState extends State<WorkVideosScreen> {
  final YouTubeService _youtubeService = YouTubeService();
  List<dynamic> _videos = [];
  bool _isLoading = false;
  String? _errorMessage; // Variable to store error message

  // Controller for the search input
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically search for videos based on the initial search query
    _searchController.text = widget.searchQuery; // Set the initial search query in the search bar
    _fetchWorkoutVideos(widget.searchQuery);
  }

  Future<void> _fetchWorkoutVideos(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      final videos = await _youtubeService.fetchWorkoutVideos(query);
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load videos. Please try again later.'; // Set error message
      });
      print('Error: $e');
    }
  }

  // Launch YouTube video by video ID
  void _launchYouTubeVideo(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Open YouTube in external app
    )) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Videos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: Container(
        color: const Color(0xFF151B54), // Background color
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Add the search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for workout videos...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Trigger a new search with the updated query
                      _fetchWorkoutVideos(_searchController.text);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        )
                      : _videos.isNotEmpty
                          ? ListView.builder(
                              itemCount: _videos.length,
                              itemBuilder: (context, index) {
                                final video = _videos[index];
                                final videoThumbnail = video['snippet']['thumbnails']['default']['url'] ??
                                    'https://via.placeholder.com/120'; // Fallback image

                                return ListTile(
                                  leading: Image.network(videoThumbnail), // Safely access thumbnail URL
                                  title: Text(
                                    video['snippet']['title'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    video['snippet']['channelTitle'],
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () {
                                    _launchYouTubeVideo(video['id']['videoId']);
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No videos found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
