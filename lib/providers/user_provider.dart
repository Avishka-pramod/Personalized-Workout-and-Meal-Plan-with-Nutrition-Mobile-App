import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _email = '';

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}