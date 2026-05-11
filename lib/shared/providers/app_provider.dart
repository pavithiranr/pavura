import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Auth state
  bool _isLoggedIn = false;
  String? _userId;
  String? _userEmail;

  // UI state
  int _currentNavIndex = 0;
  bool _isDarkMode = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  int get currentNavIndex => _currentNavIndex;
  bool get isDarkMode => _isDarkMode;

  // Auth methods
  void login(String email, String userId) {
    _isLoggedIn = true;
    _userEmail = email;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = null;
    _userEmail = null;
    _currentNavIndex = 0;
    notifyListeners();
  }

  // Navigation
  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Theme
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
