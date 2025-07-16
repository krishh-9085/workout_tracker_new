// screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../models/workout_model.dart';
import '../widgets/custom_timer.dart';

class DetailScreen extends StatefulWidget {
  final String workoutName;

  const DetailScreen({super.key, required this.workoutName});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<CustomTimerState> _timerKey = GlobalKey<CustomTimerState>();
  bool _isTimerRunning = false;

  void _saveWorkout(int actualDuration) async {
    final box = Hive.box<WorkoutModel>('workouts');
    await box.add(
      WorkoutModel(
        name: widget.workoutName,
        duration: actualDuration,
        date: DateTime.now(),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Workout saved!")));
    }
  }

  void _startWorkout() {
    _timerKey.currentState?.startTimer();
    setState(() => _isTimerRunning = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Workout started!")));
  }

  void _stopWorkout() {
    _timerKey.currentState?.stopTimer();
    setState(() => _isTimerRunning = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Workout stopped.")));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          widget.workoutName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.foregroundColor ?? theme.primaryColor,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            CustomTimer(
              key: _timerKey,
              totalSeconds: 60,
              workoutName: widget.workoutName,
              onCompleted: (int duration) {
                _saveWorkout(duration);
                setState(() => _isTimerRunning = false);
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Workout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isTimerRunning ? null : _startWorkout,
                ),
                const SizedBox(width: 16),
                if (_isTimerRunning)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _stopWorkout,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
