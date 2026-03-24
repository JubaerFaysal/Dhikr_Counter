import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/core/services/shared_preferences_service.dart';
import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';

abstract class DhikrRepository {
  DhikrModel loadState();
  Future<void> saveState(DhikrModel model);
}

class SharedPrefsDhikrRepository implements DhikrRepository {
  SharedPrefsDhikrRepository(this._service);

  final SharedPreferencesService _service;

  @override
  DhikrModel loadState() {
    return _service.loadDhikrState();
  }

  @override
  Future<void> saveState(DhikrModel model) async {
    await _service.saveDhikrState(model);
  }
}

class InMemoryDhikrRepository implements DhikrRepository {
  late DhikrModel _state = DhikrModel(
    count: AppConstants.defaultCount,
    dailyGlobalCount: AppConstants.defaultDailyGlobalCount,
    lifetimeCount: AppConstants.defaultLifetimeCount,
    goal: AppConstants.defaultGoal,
    currentDhikrIndex: AppConstants.defaultDhikrIndex,
    lastActiveDate: _todayString(),
  );

  static String _todayString() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  DhikrModel loadState() {
    return _state;
  }

  @override
  Future<void> saveState(DhikrModel model) async {
    _state = model;
  }
}
