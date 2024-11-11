import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'bottom_navigation_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _sleepingHoursController = TextEditingController();

  final List<String> _imageList = [
    'assets/images/pic_1.jpg',
    'assets/images/nutrition.jpg',
    'assets/images/9-move-body-weight-workout.jpg',
    'assets/images/pic_2_4.jpg',
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
      body: Container(
        color: const Color(0xFF101322), // Set the background color to dark blue-gray
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    'Enter Your Details',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    icon: Icons.cake,
                  ),
                  _buildTextField(
                    controller: _weightController,
                    label: 'Weight (kg)',
                    icon: Icons.fitness_center,
                  ),
                  _buildTextField(
                    controller: _heightController,
                    label: 'Height (cm)',
                    icon: Icons.height,
                  ),
                  _buildTextField(
                    controller: _sleepingHoursController,
                    label: 'Sleeping Hours',
                    icon: Icons.nightlight_round,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(
                              age: int.parse(_ageController.text),
                              weight: double.parse(_weightController.text),
                              height: double.parse(_heightController.text),
                              sleepingHours: double.parse(_sleepingHoursController.text),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: const Color(0xfffd511e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Get Recommendations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCarouselSlider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: _imageList.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}