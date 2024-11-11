import 'package:flutter/material.dart';
import 'recipe_screen.dart'; // Screen that displays search results based on nutrition
import 'package:provider/provider.dart'; // For accessing the MealProvider
import 'meal_provider.dart'; // Import MealProvider

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final TextEditingController _minCaloriesController = TextEditingController();
  final TextEditingController _maxCaloriesController = TextEditingController();
  final TextEditingController _minProteinController = TextEditingController();
  final TextEditingController _maxProteinController = TextEditingController();
  final TextEditingController _minFatController = TextEditingController();
  final TextEditingController _maxFatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search by Recipe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xFF151B54), // Set AppBar color
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF151B54), // Background color
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildNutritionInput('Min Calories', _minCaloriesController),
            _buildNutritionInput('Max Calories', _maxCaloriesController),
            _buildNutritionInput('Min Protein (g)', _minProteinController),
            _buildNutritionInput('Max Protein (g)', _maxProteinController),
            _buildNutritionInput('Min Fat (g)', _minFatController),
            _buildNutritionInput('Max Fat (g)', _maxFatController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchRecipesByNutrition,
              child: const Text('Find Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to create the text boxes with a transparent background
  Widget _buildNutritionInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white, // Label text color
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2), // Transparent text box background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white), // Text inside the box is white
      ),
    );
  }

  // Method to handle searching recipes by nutrition
  void _searchRecipesByNutrition() {
    final minCalories = _minCaloriesController.text.isNotEmpty
        ? int.tryParse(_minCaloriesController.text)
        : null;
    final maxCalories = _maxCaloriesController.text.isNotEmpty
        ? int.tryParse(_maxCaloriesController.text)
        : null;
    final minProtein = _minProteinController.text.isNotEmpty
        ? int.tryParse(_minProteinController.text)
        : null;
    final maxProtein = _maxProteinController.text.isNotEmpty
        ? int.tryParse(_maxProteinController.text)
        : null;
    final minFat = _minFatController.text.isNotEmpty
        ? int.tryParse(_minFatController.text)
        : null;
    final maxFat = _maxFatController.text.isNotEmpty
        ? int.tryParse(_maxFatController.text)
        : null;

    // Navigate to RecipeScreen and pass user inputs as filters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(
          minCalories: minCalories,
          maxCalories: maxCalories,
          minProtein: minProtein,
          maxProtein: maxProtein,
          minFat: minFat,
          maxFat: maxFat,
          searchQuery: '', additionalInfo: '', nutritionFilters: {},
        ),
      ),
    );
  }
}
