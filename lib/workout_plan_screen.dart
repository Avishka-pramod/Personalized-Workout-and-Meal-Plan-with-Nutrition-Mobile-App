import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutifitapplications/workout_video_screen.dart';
import 'package:provider/provider.dart';
import 'WorkoutProvider.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({Key? key}) : super(key: key);

  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  final List<String> _fitnessGoals = [
    'Strength',
    'Plyometrics',
    'Cardio',
    'Stretching',
    'Powerlifting',
    'Strongman',
    'Olympic Weightlifting'
  ];
  final List<String> _fitnessLevels = ['Beginner', 'Intermediate', 'Expert'];
  final List<String> _bodyParts = [
    'Abdominals',
    'Adductors',
    'Abductors',
    'Biceps',
    'Calves',
    'Chest',
    'Forearms',
    'Glutes',
    'Hamstrings',
    'Lats',
    'Lower Back',
    'Middle Back',
    'Traps',
    'Neck',
    'Quadriceps',
    'Shoulders',
    'Triceps'
  ];
  final List<String> _equipmentOptions = [
    'Bands',
    'Barbell',
    'Kettlebells',
    'Dumbbell',
    'Other',
    'Cable',
    'Machine',
    'Body Only',
    'Medicine Ball',
    'Exercise Ball',
    'Foam Roll',
    'E-Z Curl Bar'
  ];

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF151B54),
      appBar: AppBar(
        title: const Text(
          'Workout Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Workout Plan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildDropdown('Select Fitness Goal (Type)', _fitnessGoals,
                (value) {
              workoutProvider.setWorkoutSelections(
                  value!,
                  workoutProvider.fitnessLevel ?? '',
                  workoutProvider.bodyPart ?? '',
                  workoutProvider.equipment ?? '');
            }, workoutProvider.fitnessGoal),
            const SizedBox(height: 10),
            _buildDropdown('Select Fitness Level', _fitnessLevels, (value) {
              workoutProvider.setWorkoutSelections(
                  workoutProvider.fitnessGoal ?? '',
                  value!,
                  workoutProvider.bodyPart ?? '',
                  workoutProvider.equipment ?? '');
            }, workoutProvider.fitnessLevel),
            const SizedBox(height: 10),
            _buildDropdown('Select Body Part Focus', _bodyParts, (value) {
              workoutProvider.setWorkoutSelections(
                  workoutProvider.fitnessGoal ?? '',
                  workoutProvider.fitnessLevel ?? '',
                  value!,
                  workoutProvider.equipment ?? '');
            }, workoutProvider.bodyPart),
            const SizedBox(height: 10),
            _buildDropdown('Select Available Equipment', _equipmentOptions,
                (value) {
              workoutProvider.setWorkoutSelections(
                  workoutProvider.fitnessGoal ?? '',
                  workoutProvider.fitnessLevel ?? '',
                  workoutProvider.bodyPart ?? '',
                  value!);
            }, workoutProvider.equipment),
            const SizedBox(height: 20),
            // Button for fetching the workout plan
            ElevatedButton(
              onPressed: () => _fetchWorkoutPlan(context),
              child: const Text('Get Workout Plan'),
            ),
            const SizedBox(height: 20),
            if (workoutProvider.workouts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: workoutProvider.workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workoutProvider.workouts[index];
                    return _buildExerciseCard(
                        workout['Title'], workout['Reps']);
                  },
                ),
              )
            else
              const Text(
                'No workouts available. Please select options and click "Get Workout Plan".',
                style: TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items,
      Function(String?) onChanged, String? selectedValue) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      value: selectedValue != null && items.contains(selectedValue)
          ? selectedValue
          : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildExerciseCard(String title, dynamic reps) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.white),
        title: SelectableText(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
          toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
        ),
        subtitle: SelectableText(
          'Reps: ${reps.toString()}',
          style: const TextStyle(color: Colors.grey),
          toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkVideosScreen(searchQuery: title),
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchWorkoutPlan(BuildContext context) async {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    // Only fetch if all parameters are selected
    if (workoutProvider.fitnessGoal != null &&
        workoutProvider.fitnessLevel != null &&
        workoutProvider.bodyPart != null &&
        workoutProvider.equipment != null) {
      final requestBody = {
        'fitness_goal': workoutProvider.fitnessGoal,
        'fitness_level': workoutProvider.fitnessLevel,
        'body_part_focus': workoutProvider.bodyPart,
        'available_equipment': workoutProvider.equipment,
      };

      const String apiUrl = 'http://172.20.10.2:5001/suggest_workouts';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData =
              jsonDecode(response.body)['suggested_workouts'];

          final List<Map<String, dynamic>> modifiedWorkouts =
              List<Map<String, dynamic>>.from(responseData).map((workout) {
            workout['Title'] = '${workout['Title']} workout';
            return workout;
          }).toList();

          workoutProvider.setWorkouts(modifiedWorkouts);
        } else {
          print('Error fetching workout plan: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch workout plan. Error: $e');
      }
    } else {
      print('Please fill all fields before fetching the workout plan');
    }
  }
}
