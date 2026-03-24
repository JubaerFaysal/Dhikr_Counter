import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:dhikr_counter/features/dhikr/domain/repositories/dhikr_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDhikrRepository implements DhikrRepository {
  SharedPrefsDhikrRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  DhikrModel loadState() {
    final DateTime now = DateTime.now();
    final String today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return DhikrModel(
      count:
          _prefs.getInt(AppConstants.prefsCountKey) ??
          AppConstants.defaultCount,
      dailyGlobalCount:
          _prefs.getInt(AppConstants.prefsDailyGlobalCountKey) ??
          AppConstants.defaultDailyGlobalCount,
      lifetimeCount:
          _prefs.getInt(AppConstants.prefsLifetimeCountKey) ??
          AppConstants.defaultDailyGlobalCount,
      goal:
          _prefs.getInt(AppConstants.prefsGoalKey) ?? AppConstants.defaultGoal,
      currentDhikrIndex:
          _prefs.getInt(AppConstants.prefsCurrentDhikrIndexKey) ??
          AppConstants.defaultDhikrIndex,
      lastActiveDate:
          _prefs.getString(AppConstants.prefsLastActiveDateKey) ?? today,
    );
  }

  @override
  Future<void> saveState(DhikrModel model) async {
    await Future.wait(<Future<bool>>[
      _prefs.setInt(AppConstants.prefsCountKey, model.count),
      _prefs.setInt(
        AppConstants.prefsDailyGlobalCountKey,
        model.dailyGlobalCount,
      ),
      _prefs.setInt(AppConstants.prefsLifetimeCountKey, model.lifetimeCount),
      _prefs.setInt(AppConstants.prefsGoalKey, model.goal),
      _prefs.setInt(
        AppConstants.prefsCurrentDhikrIndexKey,
        model.currentDhikrIndex,
      ),
      _prefs.setString(
        AppConstants.prefsLastActiveDateKey,
        model.lastActiveDate,
      ),
    ]);
  }
}
