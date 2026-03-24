import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this.prefs);

  final SharedPreferences prefs;

  static const String themeKey = 'theme_is_dark';

  bool getTheme() => prefs.getBool(themeKey) ?? true;

  Future<void> setTheme(bool isDark) async {
    await prefs.setBool(themeKey, isDark);
  }

  DhikrModel loadDhikrState() {
    final DateTime now = DateTime.now();
    final String today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return DhikrModel(
      count:
          prefs.getInt(AppConstants.prefsCountKey) ?? AppConstants.defaultCount,
      dailyGlobalCount:
          prefs.getInt(AppConstants.prefsDailyGlobalCountKey) ??
          AppConstants.defaultDailyGlobalCount,
      lifetimeCount:
          prefs.getInt(AppConstants.prefsLifetimeCountKey) ??
          AppConstants.defaultLifetimeCount,
      goal: prefs.getInt(AppConstants.prefsGoalKey) ?? AppConstants.defaultGoal,
      currentDhikrIndex:
          prefs.getInt(AppConstants.prefsCurrentDhikrIndexKey) ??
          AppConstants.defaultDhikrIndex,
      lastActiveDate:
          prefs.getString(AppConstants.prefsLastActiveDateKey) ?? today,
    );
  }

  Future<void> saveDhikrState(DhikrModel model) async {
    await Future.wait(<Future<bool>>[
      prefs.setInt(AppConstants.prefsCountKey, model.count),
      prefs.setInt(
        AppConstants.prefsDailyGlobalCountKey,
        model.dailyGlobalCount,
      ),
      prefs.setInt(AppConstants.prefsLifetimeCountKey, model.lifetimeCount),
      prefs.setInt(AppConstants.prefsGoalKey, model.goal),
      prefs.setInt(
        AppConstants.prefsCurrentDhikrIndexKey,
        model.currentDhikrIndex,
      ),
      prefs.setString(
        AppConstants.prefsLastActiveDateKey,
        model.lastActiveDate,
      ),
    ]);
  }
}
