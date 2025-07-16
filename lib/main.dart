// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/workout_model.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme_provider.dart';

late final ThemeNotifier themeNotifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutModelAdapter());
  await Hive.openBox<WorkoutModel>('workouts');
  final settingsBox = await Hive.openBox('settings');
  themeNotifier = ThemeNotifier();

  // Load theme mode from Hive
  final storedTheme = settingsBox.get('themeMode', defaultValue: 'system');
  ThemeMode initialTheme = ThemeMode.system;
  if (storedTheme == 'light') initialTheme = ThemeMode.light;
  if (storedTheme == 'dark') initialTheme = ThemeMode.dark;

  themeNotifier.value = initialTheme;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Workout Tracker',
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurple,
              secondary: Colors.amber,
              tertiary: Colors.teal,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.deepPurple.shade200,
              secondary: Colors.amber.shade200,
              tertiary: Colors.tealAccent,
              brightness: Brightness.dark,
            ),
          ),

          // 👇 Decide home screen based on login status
          home: FirebaseAuth.instance.currentUser == null
              ? const AuthScreen()
              : const HomeScreen(),
        );
      },
    );
  }
}
