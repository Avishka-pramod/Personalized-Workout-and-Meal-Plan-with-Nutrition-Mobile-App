import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'input_screen.dart';
import 'providers/user_provider.dart';
import 'nutrition_provider.dart';
import 'meal_provider.dart'; // MealProvider
import 'splash_screen.dart';
import 'meal_plan_screen.dart';
import 'workout_video_screen.dart';
import 'nutrition_recommendation_screen.dart';
import 'workout_plan_screen.dart';
import 'WorkoutProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase successfully initialized.');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // User Provider
        ChangeNotifierProvider(create: (_) => NutritionProvider()), // Nutrition Provider
        ChangeNotifierProvider(create: (_) => MealProvider()), // Meal Provider
        ChangeNotifierProvider(create: (_) => WorkoutProvider()), // Workout Provider
      ],
      child: MaterialApp(
        title: 'Personalized Workout App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // Splash Screen route
          '/input': (context) => const InputScreen(), // Input Screen route
          '/mealPlan': (context) => const MealPlanScreen(), // Meal Plan route
          '/workoutVideos': (context) => WorkVideosScreen(searchQuery: 'workout'), // Pass a default search query here
          '/nutrition': (context) => const NutritionRecommendationScreen(), // Nutrition Screen route
          '/workoutPlan': (context) => const WorkoutPlanScreen(), // Workout Plan Screen route
        },
        debugShowCheckedModeBanner: false, // Disable debug banner
      ),
    );
  }
}
