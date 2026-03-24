import 'package:dhikr_counter/core/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
  ref,
) {
  throw UnimplementedError(
    'sharedPreferencesServiceProvider must be overridden',
  );
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(this._service) : super(_service.getTheme());

  final SharedPreferencesService _service;

  Future<void> toggleTheme() async {
    state = !state;
    await _service.setTheme(state);
  }

  bool get isDark => state;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  final service = ref.watch(sharedPreferencesServiceProvider);
  return ThemeNotifier(service);
});
