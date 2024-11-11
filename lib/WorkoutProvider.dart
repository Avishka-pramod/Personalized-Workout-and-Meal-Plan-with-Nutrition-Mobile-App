import 'package:flutter/material.dart';

class WorkoutProvider with ChangeNotifier {
  String? fitnessGoal;
  String? fitnessLevel;
  String? bodyPart;
  String? equipment;
  List<Map<String, dynamic>> workouts = [];

  void setWorkoutSelections(String goal, String level, String part, String equip) {
    fitnessGoal = goal;
    fitnessLevel = level;
    bodyPart = part;
    equipment = equip;
    notifyListeners();
  }

  void setWorkouts(List<Map<String, dynamic>> newWorkouts) {
    workouts = newWorkouts;
    notifyListeners();
  }

  void clearWorkouts() {
    workouts.clear();
    notifyListeners();
  }
}
