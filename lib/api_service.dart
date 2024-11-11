import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'f2e93c23926a4fb3ac9b2d2c602ade65'; // Replace with your actual API key
  final String baseUrl = 'https://api.spoonacular.com';

  // Search recipes based on multiple nutrition values and query
  Future<List<dynamic>> searchRecipesByNutrition({
    int? minCalories,
    int? maxCalories,
    int? minProtein,
    int? maxProtein,
    int? minFat,
    int? maxFat,
    required String searchQuery, // Add search query parameter
  }) async {
    String url = '$baseUrl/recipes/complexSearch?apiKey=$apiKey';

    // Add nutrition filters if provided
    if (minCalories != null) url += '&minCalories=$minCalories';
    if (maxCalories != null) url += '&maxCalories=$maxCalories';
    if (minProtein != null) url += '&minProtein=$minProtein';
    if (maxProtein != null) url += '&maxProtein=$maxProtein';
    if (minFat != null) url += '&minFat=$minFat';

    // Add search query to the API request
    if (searchQuery.isNotEmpty) url += '&query=$searchQuery';

    print('API URL: $url'); // Debug statement to log the API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results']; // Contains an array of recipes
      } else {
        throw Exception('Failed to search recipes by nutrition');
      }
    } catch (e) {
      print('Error fetching recipes: $e'); // Catch network or parsing errors
      throw Exception('Error occurred while fetching recipes');
    }
  }

  // Fetch detailed information about a specific recipe by its ID
  Future<Map<String, dynamic>> getRecipeDetails(int recipeId) async {
    final String url = '$baseUrl/recipes/$recipeId/information?apiKey=$apiKey';

    print('Fetching recipe details from: $url'); // Debug statement

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Return the detailed recipe information
      } else {
        throw Exception('Failed to fetch recipe details');
      }
    } catch (e) {
      print('Error fetching recipe details: $e'); // Catch network or parsing errors
      throw Exception('Error occurred while fetching recipe details');
    }
  }
}
