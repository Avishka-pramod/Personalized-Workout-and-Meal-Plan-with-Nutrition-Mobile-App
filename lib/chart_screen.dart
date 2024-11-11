import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chart Screen',
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
      body: const Center(
        child: Text(
          'This is the Chart Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
