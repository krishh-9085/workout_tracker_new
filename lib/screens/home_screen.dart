// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import 'auth_screen.dart';
import 'workout_history_screen.dart';
import 'upper_body_screen.dart';
import 'lower_body_screen.dart';
import 'cardio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> workouts = [
      {
        'title': 'Upper Body Strength',
        'subtitle': 'Build upper body strength with compound movements',
        'duration': '45 min',
        'badge': 'Intermediate',
        'badgeColor': Colors.green,
        'screen': const UpperBodyScreen(),
      },
      {
        'title': 'Lower Body Power',
        'subtitle': 'Explosive lower body exercises for power and strength',
        'duration': '35 min',
        'badge': 'Advanced',
        'badgeColor': Colors.orange,
        'screen': const LowerBodyWorkoutScreen(),
      },
      {
        'title': 'Core & Cardio',
        'subtitle': 'High-intensity core and cardio combination',
        'duration': '25 min',
        'badge': 'Beginner',
        'badgeColor': Colors.blue,
        'screen': const CardioWorkoutScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80, // ⬅️ Increased height
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Workout Tracker',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 24, // ⬅️ Larger font
            ),
          ),
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
      ),
      child: IconButton(
        icon: Icon(
          themeNotifier.value == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
          size: 26,
        ),
        tooltip: 'Toggle Theme',
        onPressed: () {
          themeNotifier.toggleTheme(); // ✅ Persisted toggle
        },
      ),
    ),
  ),
],


      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Greeting
            Card(
              color: isDark ? Colors.deepPurple[800] : Colors.deepPurple[50],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Buddy!",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "ready for your workout?",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      radius: 24,
                      child: const Icon(
                        Icons.person, // 👤 Default profile icon
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section Title
            Text(
              "Your Workouts",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Workout Cards
            ...workouts.map((w) {
              final title = w['title'] as String;
              final subtitle = w['subtitle'] as String;
              final duration = w['duration'] as String;
              final badge = w['badge'] as String;
              final badgeColor = w['badgeColor'] as Color;
              final screen = w['screen'] as Widget;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => screen),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  color: isDark
                      ? const Color.fromARGB(255, 28, 28, 28)
                      : Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              duration,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                badge,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: badgeColor,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.iconTheme.color?.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.unselectedWidgetColor.withOpacity(0.7),
          backgroundColor: Theme.of(context).colorScheme.primary,

          elevation: 12,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          iconSize: 28,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, color: Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded, color: Colors.black),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded, color: Colors.black),
              label: 'Logout',
            ),
          ],
          onTap: (index) async {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen()),
              );
            } else if (index == 2) {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                _logout(context);
              }
            }
          },
        ),
      ),
    );
  }
}
