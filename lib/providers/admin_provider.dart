import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void toggleAdmin() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }
}