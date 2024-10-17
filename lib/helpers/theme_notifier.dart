import 'package:flutter/material.dart';
import 'package:scrawler/helpers/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Color selectedPrimaryColor = globals.appColors[0];

  ThemeNotifier() {
    _loadSeedColor();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSelectedPrimaryColor(Color color) {
    selectedPrimaryColor = color;
    _saveSeedColor(color);
    notifyListeners();
  }

  // Load the seed color from SharedPreferences
  Future<void> _loadSeedColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('seedColor');
    if (colorValue != null) {
      selectedPrimaryColor = Color(colorValue);
      notifyListeners();
    }
  }

  // Save the seed color to SharedPreferences
  Future<void> _saveSeedColor(Color color) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seedColor', color.value);
  }
}
