import 'package:flutter/material.dart';
import 'package:nutifitapplications/workout_video_screen.dart'; // Remove duplicate import

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: Container(
        color: const Color(0xFF151B54), // Set the background color
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHomeScreenContent(),
                const SizedBox(height: 20), // Add some space between elements
                ElevatedButton(
                  onPressed: () {
                    // Navigate to WorkVideosScreen with a search query
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkVideosScreen(searchQuery: 'injury prevention'), // Pass a valid search query
                      ),
                    );
                  },
                  child: const Text('Go to Injury Prevention'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    // Add more home screen content if needed
    return const Text(
      'Welcome to the Workout App!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
