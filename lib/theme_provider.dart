// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  final Box settingsBox = Hive.box('settings');

  ThemeNotifier() : super(ThemeMode.system) {
    final savedTheme = settingsBox.get('themeMode', defaultValue: 'system');
    value = _stringToThemeMode(savedTheme);
  }

  void toggleTheme() {
    if (value == ThemeMode.dark) {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.dark;
    }
    settingsBox.put('themeMode', _themeModeToString(value));
  }

  static ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
