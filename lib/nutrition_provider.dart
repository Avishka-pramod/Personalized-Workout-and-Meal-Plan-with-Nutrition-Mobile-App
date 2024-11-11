import 'package:flutter/material.dart';

class NutritionProvider with ChangeNotifier {
  List<dynamic> _mealRecommendations = [];

  List<dynamic> get mealRecommendations => _mealRecommendations;

  void setMealRecommendations(List<dynamic> meals) {
    _mealRecommendations = meals;
    notifyListeners();  // Notify listeners that state has changed
  }

  // Clear meal recommendations if needed
  void clearRecommendations() {
    _mealRecommendations = [];
    notifyListeners();
  }

  // Check if meal recommendations are already set
  bool hasRecommendations() {
    return _mealRecommendations.isNotEmpty;
  }
}
