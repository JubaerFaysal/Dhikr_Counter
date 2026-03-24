import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/core/theme/app_theme.dart';
import 'package:dhikr_counter/features/dhikr/data/repositories/shared_prefs_dhikr_repository.dart';
import 'package:dhikr_counter/features/dhikr/presentation/providers/dhikr_provider.dart';
import 'package:dhikr_counter/features/dhikr/presentation/screens/dhikr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: <Override>[
        dhikrRepositoryProvider.overrideWithValue(
          SharedPrefsDhikrRepository(preferences),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: AppTheme.darkTheme,
      home: const DhikrScreen(),
    );
  }
}
