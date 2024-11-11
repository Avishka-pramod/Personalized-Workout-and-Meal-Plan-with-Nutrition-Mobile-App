import 'package:flutter/material.dart';
import 'api_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? _recipeDetails;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipeDetails();
  }

  Future<void> _fetchRecipeDetails() async {
    try {
      Map<String, dynamic> recipeDetails = await apiService.getRecipeDetails(widget.recipeId);
      setState(() {
        _recipeDetails = recipeDetails;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print('Error fetching recipe details: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _recipeDetails != null ? _recipeDetails!['title'] : 'Loading...',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text(
                    'Failed to load recipe details',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : _recipeDetails != null
                  ? Container(
                      color: const Color(0xFF151B54),
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          _recipeDetails!['image'] != null
                              ? Image.network(_recipeDetails!['image'], fit: BoxFit.cover)
                              : const SizedBox.shrink(), // Show nothing if there's no image
                          const SizedBox(height: 20),
                          const Text(
                            'Ingredients:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          _recipeDetails!['extendedIngredients'] != null
                              ? Column(
                                  children: _recipeDetails!['extendedIngredients'].map<Widget>((ingredient) {
                                    return Text(
                                      '• ${ingredient['original']}',
                                      style: const TextStyle(color: Colors.white),
                                    );
                                  }).toList(),
                                )
                              : const Text(
                                  'No ingredients available.',
                                  style: TextStyle(color: Colors.white),
                                ),
                          const SizedBox(height: 20),
                          const Text(
                            'Preparation Steps:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          _recipeDetails!['analyzedInstructions'] != null &&
                                  _recipeDetails!['analyzedInstructions'].isNotEmpty
                              ? Column(
                                  children: _recipeDetails!['analyzedInstructions'][0]['steps'].map<Widget>((step) {
                                    return Text(
                                      '${step['number']}. ${step['step']}',
                                      style: const TextStyle(color: Colors.white),
                                    );
                                  }).toList(),
                                )
                              : const Text(
                                  'No preparation steps available.',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No recipe details available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
    );
  }
}
