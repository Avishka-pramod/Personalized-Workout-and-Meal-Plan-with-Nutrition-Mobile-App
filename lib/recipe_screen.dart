import 'package:flutter/material.dart';
import 'api_service.dart';
import 'recipe_detail_screen.dart'; // Import the RecipeDetailScreen

class RecipeScreen extends StatefulWidget {
  final int? minCalories;
  final int? maxCalories;
  final int? minProtein;
  final int? maxProtein;
  final int? minFat;
  final int? maxFat;
  final String searchQuery; // Added parameter for search query
  final String additionalInfo; // Added parameter for additional info

  const RecipeScreen({
    Key? key,
    this.minCalories,
    this.maxCalories,
    this.minProtein,
    this.maxProtein,
    this.minFat,
    this.maxFat,
    required this.searchQuery, // Use required for non-nullable parameters
    required this.additionalInfo, required Map<String, int?> nutritionFilters,
  }) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipesByNutrition();
  }

  Future<void> _fetchRecipesByNutrition() async {
    try {
      print('Fetching recipes with search query: ${widget.searchQuery}'); // Debug statement
      List<dynamic> recipes = await apiService.searchRecipesByNutrition(
        minCalories: widget.minCalories,
        maxCalories: widget.maxCalories,
        minProtein: widget.minProtein,
        maxProtein: widget.maxProtein,
        minFat: widget.minFat,
        maxFat: widget.maxFat,
        searchQuery: widget.searchQuery, // Make sure search query is used
      );

      print('Fetched Recipes: $recipes'); // Debug statement to log the fetched recipes

      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipes Based on Query',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ), // Set text color to white
        ),
        backgroundColor: const Color(0xFF151B54), // Navbar color
      ),
      body: Container(
        color: const Color(0xFF151B54), // Background color
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recipes.isNotEmpty
                ? ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Card(
                        color: Colors.white.withOpacity(0.5), // Transparent background for cards
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            recipe['image'] ?? 'https://via.placeholder.com/100', // Handle missing images
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            recipe['title'] ?? 'Unknown',
                            style: const TextStyle(color: Colors.white), // Title text color white
                          ),
                          subtitle: Text(
                            'Ready in ${recipe['readyInMinutes'] ?? 'N/A'} minutes',
                            style: const TextStyle(color: Colors.white70), // Subtitle text color
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipeId: recipe['id']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No recipes found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
      ),
    );
  }
}
