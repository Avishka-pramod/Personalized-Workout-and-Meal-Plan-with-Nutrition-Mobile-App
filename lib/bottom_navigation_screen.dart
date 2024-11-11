import 'package:flutter/material.dart';
import 'workout_video_screen.dart';
import 'workout_plan_screen.dart';
import 'meal_plan_screen.dart';
import 'nutrition_recommendation_screen.dart';
import 'input_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int age;
  final double weight;
  final double height;
  final double sleepingHours;

  const BottomNavigationScreen({
    Key? key,
    required this.age,
    required this.weight,
    required this.height,
    required this.sleepingHours,
  }) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WorkoutPlanScreen(),
    const MealPlanScreen(),
    const NutritionRecommendationScreen(),
    WorkVideosScreen(searchQuery: 'workout videos'), // Pass a valid search query here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NUTRIFIT GENIUS',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'sans-serif-medium',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 4,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xfffd511e),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF101322),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xfffd511e),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  if (_currentIndex != 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const InputScreen()),
                    );
                  } else {
                    Navigator.pop(context); // Close the drawer if already on InputScreen
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: const Color(0xfffd511e), // Orange color above the navigation bar
            height: 5.0,
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Workout Plan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_sharp),
                label: 'Meal Recipe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank),
                label: 'Nutrition',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.youtube_searched_for_sharp),
                label: 'Videos',
              ),
            ],
            backgroundColor: const Color(0xFF101322),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            type: BottomNavigationBarType.fixed,
          ),
        ],
      ),
    );
  }
}
