// screens/upper_body_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../models/workout_model.dart';
import '../widgets/custom_timer.dart';

class UpperBodyScreen extends StatefulWidget {
  const UpperBodyScreen({super.key});

  @override
  State<UpperBodyScreen> createState() => _UpperBodyScreenState();
}

class _UpperBodyScreenState extends State<UpperBodyScreen> {
  final GlobalKey<CustomTimerState> _timerKey = GlobalKey<CustomTimerState>();
  bool _isTimerRunning = false;
  int _totalSeconds = 300;

  final Map<String, List<String>> _exercises = {
    'Back': ['Pull-Ups', 'Lat Pulldown', 'Bent-over Rows'],
    'Chest': ['Bench Press', 'Incline Dumbbell Press', 'Push-Ups'],
    'Biceps': ['Barbell Curls', 'Hammer Curls', 'Concentration Curls'],
    'Triceps': ['Tricep Dips', 'Overhead Tricep Extension', 'Tricep Kickbacks'],
    'Shoulders': ['Shoulder Press', 'Lateral Raises', 'Front Raises'],
  };

  final Map<String, String> _exerciseIcons = {
    'Pull-Ups': 'assets/icons/pull.png',
    'Lat Pulldown': 'assets/icons/pull-down.png',
    'Bent-over Rows': 'assets/icons/back.png',
    'Bench Press': 'assets/icons/bench press.png',
    'Incline Dumbbell Press': 'assets/icons/incline dumbell.png',
    'Push-Ups': 'assets/icons/pushup.png',
    'Barbell Curls': 'assets/icons/barbell curll.png',
    'Hammer Curls': 'assets/icons/hammer curl.png',
    'Concentration Curls': 'assets/icons/concentration.png',
    'Tricep Dips': 'assets/icons/dips.png',
    'Overhead Tricep Extension': 'assets/icons/overhead.png',
    'Tricep Kickbacks': 'assets/icons/kickback.png',
    'Shoulder Press': 'assets/icons/shoulder press.png',
    'Lateral Raises': 'assets/icons/sides.png',
    'Front Raises': 'assets/icons/front.png',
  };

  void _saveWorkout(int duration) async {
    final box = Hive.box<WorkoutModel>('workouts');
    final model = WorkoutModel(
      name: 'Upper Body Strength',
      duration: duration,
      date: DateTime.now(),
    );
    await box.add(model);

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
        toolbarHeight: 80, // ⬆️ Increased height
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.deepPurple,
        foregroundColor: theme.appBarTheme.foregroundColor ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Upper Body Strength',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15, // ⬆️ Larger text
              color: theme.appBarTheme.foregroundColor ?? Colors.white,
            ),
          ),
        ),
        centerTitle: true, // Or true if you prefer centered
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                      Text(
                        "30 min",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _totalSeconds.toDouble(),
                    min: 60,
                    max: 1800,
                    divisions: 29,
                    label:
                        "${(_totalSeconds ~/ 60).toString().padLeft(2, '0')} min",
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: theme.colorScheme.primary.withOpacity(0.3),
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
            const SizedBox(height: 20),

            Center(
              child: CustomTimer(
                key: _timerKey,
                totalSeconds: _totalSeconds,
                workoutName: 'Upper Body Strength',
                onCompleted: (int duration) {
                  _saveWorkout(duration);
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
            const SizedBox(height: 30),
            Text(
              "Workout Sections",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            ..._exercises.entries.map((entry) {
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
                child: _exerciseIcons.containsKey(exercise)
                    ? Image.asset(
                        _exerciseIcons[exercise]!,
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
