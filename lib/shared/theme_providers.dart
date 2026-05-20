import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Initialize SharedPreferences and load saved theme
  Future<void> _loadThemeFromPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedTheme = _prefs.getString(_themeKey);

      if (savedTheme != null) {
        _themeMode = _stringToThemeMode(savedTheme);
      } else {
        // Default to system theme if nothing is saved
        _themeMode = ThemeMode.system;
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme from preferences: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    try {
      await _prefs.setString(_themeKey, _themeModeToString(_themeMode));
    } catch (e) {
      debugPrint('Error saving theme to preferences: $e');
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      await _saveThemeToPrefs();
      notifyListeners();
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  // Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  // Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  // Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // Get current theme brightness based on system
  Brightness getCurrentBrightness(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness;
    }
  }

  // Check if current theme is dark
  bool isDark(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  // Helper methods for string conversion
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // Reset to default theme
  Future<void> resetTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // Get theme mode display name
  String getThemeModeDisplayName() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  // Get theme mode icon
  IconData getThemeModeIcon() {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }
}
