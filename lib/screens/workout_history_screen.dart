// screens/workout_history_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<WorkoutModel>('workouts');
    final theme = Theme.of(context);
    String formatDuration(int seconds) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (minutes > 0) {
        return '${minutes}m ${remainingSeconds}s';
      } else {
        return '${remainingSeconds}s';
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80, // ⬆️ Increased height
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.deepPurple,
        foregroundColor: theme.appBarTheme.foregroundColor ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Workout History',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 24, // ⬆️ Larger text
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
            ),
          ),
        ),
        centerTitle: true, // Or true if you prefer centered
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<WorkoutModel> box, _) {
          final workouts = box.values.toList().reversed.toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: workouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No workouts yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Start working out to see your history here.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.fitness_center,
                            color: Colors.deepPurple,
                          ),
                          title: Text(
                            workout.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          subtitle: Text(
                            '${formatDuration(workout.duration)} • ${DateFormat.yMMMd().format(workout.date)}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteWorkout(context, workout),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _deleteWorkout(BuildContext context, WorkoutModel workout) async {
    final box = Hive.box<WorkoutModel>('workouts');
    final key = box.keys.firstWhere(
      (k) => box.get(k) == workout,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }
}
