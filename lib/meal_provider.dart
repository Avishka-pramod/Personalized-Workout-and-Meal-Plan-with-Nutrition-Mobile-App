import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  List<dynamic> _mealPlans = []; // Store meal plan data

  List<dynamic> get mealPlans => _mealPlans;

  void setMealPlans(List<dynamic> mealPlans) {
    _mealPlans = mealPlans;
    notifyListeners(); // Notify listeners that the state has changed
  }

  void clearMealPlans() {
    _mealPlans = [];
    notifyListeners(); // Notify listeners to update the state
  }

  bool hasMealPlans() {
    return _mealPlans.isNotEmpty;
  }
}
