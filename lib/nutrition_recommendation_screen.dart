import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'nutrition_provider.dart'; // Import your state management (Provider)

class NutritionRecommendationScreen extends StatefulWidget {
  const NutritionRecommendationScreen({Key? key}) : super(key: key);

  @override
  _NutritionRecommendationScreenState createState() =>
      _NutritionRecommendationScreenState();
}

class _NutritionRecommendationScreenState
    extends State<NutritionRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _target;
  String? _timeOfDay;
  bool _isLoading = false;
  bool _hasError = false;

  final List<String> _targets = ['bulk', 'fat_loss', 'maintenance'];
  final List<String> _timesOfDay = ['breakfast', 'lunch', 'dinner'];

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Plan With Nutrition',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: Container(
        color: const Color(0xFF151B54),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTargetDropdown(),
              const SizedBox(height: 20),
              _buildTimeOfDayDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Get Recommendations',
                  style: TextStyle(color: Color(0xFF151B54)),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildNutritionRecommendations(
                      nutritionProvider.mealRecommendations),
              if (_hasError) _buildErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Target',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.black.withOpacity(0.8),
      value: _target,
      onChanged: (value) {
        setState(() {
          _target = value;
        });
      },
      items: _targets.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a target' : null,
    );
  }

  Widget _buildTimeOfDayDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Time of Day',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.black.withOpacity(0.8),
      value: _timeOfDay,
      onChanged: (value) {
        setState(() {
          _timeOfDay = value;
        });
      },
      items: _timesOfDay.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      validator: (value) =>
          value == null ? 'Please select a time of day' : null,
    );
  }

  Widget _buildNutritionRecommendations(List<dynamic> mealRecommendations) {
    return mealRecommendations.isEmpty
        ? Card(
            color: Colors.black,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your personalized meal plan will be displayed here.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Column(
            children: mealRecommendations.map((meal) {
              final String recipeName =
                  meal['Recipe_name']?.toString() ?? 'Unknown Recipe';
              final String protein = meal['Protein(g)']?.toString() ?? 'N/A';
              final String carbs = meal['Carbs(g)']?.toString() ?? 'N/A';
              final String fat = meal['Fat(g)']?.toString() ?? 'N/A';

              return Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Colors.white, width: 1.5),
                ),
                child: ListTile(
                  title: Text(
                    recipeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Protein: $protein g, Carbs: $carbs g, Fat: $fat g',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  onTap: () => _launchYouTubeSearch(recipeName),
                ),
              );
            }).toList(),
          );
  }

  Future<void> _launchYouTubeSearch(String recipeName) async {
    final Uri searchUrl = Uri.parse(
        'https://www.youtube.com/results?search_query=$recipeName recipe');
    if (await canLaunchUrl(searchUrl)) {
      await launchUrl(searchUrl);
    } else {
      print('Could not launch YouTube for $recipeName');
    }
  }

  Widget _buildErrorMessage() {
    return const Card(
      color: Colors.redAccent,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Error fetching recommendations. Please try again later.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    final String apiUrl = 'http://172.20.10.2:5000/get_meal_plan';
    final uri = Uri.parse('$apiUrl?target=$_target&time_of_day=$_timeOfDay');

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Provider.of<NutritionProvider>(context, listen: false)
            .setMealRecommendations(responseData['meals']);
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
