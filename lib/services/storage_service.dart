// services/storage_service.dart
import 'package:hive/hive.dart';
import '../models/workout_model.dart';

class StorageService {
  static const String boxName = 'workouts';

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutModelAdapter());
    }
    await Hive.openBox<WorkoutModel>(boxName);
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    final box = Hive.box<WorkoutModel>(boxName);
    await box.add(workout); // Auto key
  }

  List<WorkoutModel> getAllWorkouts() {
    final box = Hive.box<WorkoutModel>(boxName);
    return box.values.toList();
  }

  Future<void> clearAll() async {
    final box = Hive.box<WorkoutModel>(boxName);
    await box.clear();
  }
}
