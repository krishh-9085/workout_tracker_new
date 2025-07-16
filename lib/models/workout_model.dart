// models/workout_model.dart
import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int duration;

  @HiveField(2)
  DateTime date;

  WorkoutModel({
    required this.name,
    required this.duration,
    required this.date,
  });
}
