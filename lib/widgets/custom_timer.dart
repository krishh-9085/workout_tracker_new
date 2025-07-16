// widgets/custom_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CustomTimer extends StatefulWidget {
  final int totalSeconds;
  final Function(int) onCompleted; // ✅ Accept duration in seconds
  final String workoutName;

  const CustomTimer({
    super.key,
    required this.totalSeconds,
    required this.onCompleted,
    required this.workoutName,
  });

  @override
  CustomTimerState createState() => CustomTimerState();
}

class CustomTimerState extends State<CustomTimer> {
  late int remainingSeconds;
  Timer? _timer;
  bool isRunning = false;
  bool _alreadyCompleted = false;
  DateTime? _startTime; // ✅ Track when workout started

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.totalSeconds;
  }

  void startTimer() {
    stopTimer();
    setState(() {
      isRunning = true;
      _alreadyCompleted = false;
      _startTime = DateTime.now(); // ✅ Capture start time
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        stopTimer();
        if (!_alreadyCompleted) {
          _alreadyCompleted = true;
          final elapsed = _getElapsedSeconds();
          widget.onCompleted(elapsed); // ✅ Pass elapsed
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Time's up!")));
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    if (isRunning && !_alreadyCompleted) {
      _alreadyCompleted = true;
      final elapsed = _getElapsedSeconds();
      widget.onCompleted(elapsed); // ✅ Pass elapsed
    }
    setState(() {
      isRunning = false;
      remainingSeconds = widget.totalSeconds;
    });
  }

  int _getElapsedSeconds() {
    if (_startTime == null) return 0;
    final now = DateTime.now();
    return now.difference(_startTime!).inSeconds.clamp(1, widget.totalSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: remainingSeconds / widget.totalSeconds,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple,
                ),
              ),
            ),
            Text(
              "$minutes:$seconds",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          isRunning ? "Timer running..." : "Timer ready",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
