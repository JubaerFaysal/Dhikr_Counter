import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/core/providers/theme_provider.dart';
import 'package:dhikr_counter/core/services/shared_preferences_service.dart';
import 'package:dhikr_counter/core/theme/app_theme.dart';
import 'package:dhikr_counter/features/dhikr/data/repositories/dhikr_repository.dart';
import 'package:dhikr_counter/features/dhikr/presentation/providers/dhikr_provider.dart';
import 'package:dhikr_counter/features/dhikr/presentation/screens/dhikr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final SharedPreferencesService service = SharedPreferencesService(
    preferences,
  );

  runApp(
    ProviderScope(
      overrides: <Override>[
        sharedPreferencesServiceProvider.overrideWithValue(service),
        dhikrRepositoryProvider.overrideWithValue(
          SharedPrefsDhikrRepository(service),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const DhikrScreen(),
    );
  }
}
