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
    final String today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return DhikrModel(
      count: prefs.getInt(AppConstants.count) ?? AppConstants.defaultCount,
      dailyGlobalCount: prefs.getInt(AppConstants.dailyGlobalCount) ?? AppConstants.defaultDailyGlobalCount,
      lifetimeCount: prefs.getInt(AppConstants.lifetimeCount) ?? AppConstants.defaultLifetimeCount,
      goal: prefs.getInt(AppConstants.goal) ?? AppConstants.defaultGoal,
      currentDhikrIndex: prefs.getInt(AppConstants.currentDhikrIndex) ?? AppConstants.defaultDhikrIndex,
      lastActiveDate: prefs.getString(AppConstants.lastActiveDate) ?? today,
    );
  }

  Future<void> saveDhikrState(DhikrModel model) async {
    await Future.wait(<Future<bool>>[
      prefs.setInt(AppConstants.count, model.count),
      prefs.setInt(AppConstants.dailyGlobalCount, model.dailyGlobalCount,),
      prefs.setInt(AppConstants.lifetimeCount, model.lifetimeCount),
      prefs.setInt(AppConstants.goal, model.goal),
      prefs.setInt(AppConstants.currentDhikrIndex, model.currentDhikrIndex,),
      prefs.setString(AppConstants.lastActiveDate, model.lastActiveDate,),
    ]);
  }
}
