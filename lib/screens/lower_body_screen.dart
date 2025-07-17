// screens/lower_body_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../models/workout_model.dart';
import '../widgets/custom_timer.dart';

class LowerBodyWorkoutScreen extends StatefulWidget {
  const LowerBodyWorkoutScreen({super.key});

  @override
  State<LowerBodyWorkoutScreen> createState() => _LowerBodyWorkoutScreenState();
}

class _LowerBodyWorkoutScreenState extends State<LowerBodyWorkoutScreen> {
  final GlobalKey<CustomTimerState> _timerKey = GlobalKey<CustomTimerState>();
  bool _isTimerRunning = false;
  int _totalSeconds = 300;

  final Map<String, List<String>> lowerBodyExercises = {
    "Quads": ["Squats", "Leg Press", "Lunges"],
    "Hamstrings": ["Romanian Deadlifts", "Hamstring Curls", "Glute Bridges"],
    "Glutes": ["Hip Thrusts", "Step-Ups", "Donkey Kicks"],
    "Calves": ["Standing Calf Raises", "Seated Calf Raises"],
  };

  final Map<String, String> exerciseIcons = {
    "Squats": "assets/icons/squats.png",
    "Leg Press": "assets/icons/leg press.png",
    "Lunges": "assets/icons/lenges.png",
    "Romanian Deadlifts": "assets/icons/deadlift.png",
    "Hamstring Curls": "assets/icons/hamstring-curl.png",
    "Glute Bridges": "assets/icons/glute bridge.png",
    "Hip Thrusts": "assets/icons/hip.png",
    "Step-Ups": "assets/icons/step-up.png",
    "Donkey Kicks": "assets/icons/donkey.png",
    "Standing Calf Raises": "assets/icons/calfs.png",
    "Seated Calf Raises": "assets/icons/sitted calf.png",
  };

  void _saveWorkout(int duration) async {
    final box = Hive.box<WorkoutModel>('workouts');
    final workout = WorkoutModel(
      name: "Lower Body Workout",
      duration: duration,
      date: DateTime.now(),
    );
    await box.add(workout);
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
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.deepPurple,
        foregroundColor: theme.appBarTheme.foregroundColor ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Lower Body Workout',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Timer Duration Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Workout Duration",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "1 min",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            "30 min",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _totalSeconds.toDouble(),
                        min: 60,
                        max: 1800,
                        divisions: 29,
                        label: "${(_totalSeconds ~/ 60)} min",
                        activeColor: theme.colorScheme.primary,
                        inactiveColor: theme.colorScheme.primary.withOpacity(
                          0.3,
                        ),
                        onChanged: _isTimerRunning
                            ? null
                            : (value) {
                                setState(() {
                                  _totalSeconds = value.toInt();
                                });
                              },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${(_totalSeconds ~/ 60).toString().padLeft(2, '0')} min ${(_totalSeconds % 60).toString().padLeft(2, '0')} sec",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomTimer(
                key: _timerKey,
                totalSeconds: _totalSeconds,
                workoutName: "Lower Body Workout",
                onCompleted: (int actualDuration) {
                  _saveWorkout(actualDuration);
                  setState(() => _isTimerRunning = false);
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Workout"),
                  onPressed: _isTimerRunning ? null : _startWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (_isTimerRunning)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    onPressed: _stopWorkout,
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
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercise Categories",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...lowerBodyExercises.entries.map((entry) {
             
  return Theme(
    data: Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          collapsedBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: theme.colorScheme.primary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: const Icon(Icons.fitness_center),
          title: Text(
            entry.key,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: theme.colorScheme.onSurface,
            ),
          ),
          children: entry.value.map((exercise) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: exerciseIcons.containsKey(exercise)
                    ? Image.asset(
                        exerciseIcons[exercise]!,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.fitness_center,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        Icons.fitness_center,
                        color: theme.colorScheme.primary,
                      ),
              ),
              title: Text(
                exercise,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
})

          ],
        ),
      ),
    );
  }
}
