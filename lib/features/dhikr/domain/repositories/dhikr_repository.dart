import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';

abstract class DhikrRepository {
  DhikrModel loadState();
  Future<void> saveState(DhikrModel model);
}
