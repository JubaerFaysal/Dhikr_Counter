import 'dart:async';

import 'package:dhikr_counter/core/constants/app_constants.dart';
import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:dhikr_counter/features/dhikr/domain/repositories/dhikr_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<DhikrRepository> dhikrRepositoryProvider =
    Provider<DhikrRepository>((Ref ref) => InMemoryDhikrRepository());

final NotifierProvider<DhikrViewModel, DhikrModel> dhikrViewModelProvider =
    NotifierProvider<DhikrViewModel, DhikrModel>(DhikrViewModel.new);

class DhikrViewModel extends Notifier<DhikrModel> {
  static const List<DhikrPhraseModel> _phrases = <DhikrPhraseModel>[
    DhikrPhraseModel(
      arabic: 'سُبْحَانَ ٱللَّٰهِ',
      transliteration: 'SUBHANALLAH',
      meaning: 'GLORY BE TO ALLAH',
    ),
    DhikrPhraseModel(
      arabic: 'ٱلْحَمْدُ لِلَّٰهِ',
      transliteration: 'ALHAMDULILLAH',
      meaning: 'ALL PRAISE IS FOR ALLAH',
    ),
    DhikrPhraseModel(
      arabic: 'ٱللَّٰهُ أَكْبَرُ',
      transliteration: 'ALLAHU AKBAR',
      meaning: 'ALLAH IS THE GREATEST',
    ),
  ];

  List<DhikrPhraseModel> get phrases => _phrases;
  static const List<int> goalPresets = <int>[33, 99, 100];

  Timer? _saveDebounce;

  DhikrRepository get _repository => ref.read(dhikrRepositoryProvider);

  @override
  DhikrModel build() {
    ref.onDispose(() {
      _saveDebounce?.cancel();
    });

    final DhikrModel loaded = _repository.loadState();
    return _normalizeForToday(loaded);
  }

  void recite() {
    if (state.count >= state.goal) {
      return;
    }

    final int nextCount = (state.count + 1).clamp(0, state.goal);

    state = state.copyWith(
      count: nextCount,
      dailyGlobalCount: state.dailyGlobalCount + 1,
      lifetimeCount: state.lifetimeCount + 1,
      lastActiveDate: _todayString(),
    );
    _persist();
  }

  void switchDhikr() {
    state = state.copyWith(
      currentDhikrIndex: (state.currentDhikrIndex + 1) % _phrases.length,
      count: 0,
      lastActiveDate: _todayString(),
    );
    _persist();
  }

  void resetSession() {
    state = state.copyWith(count: 0, lastActiveDate: _todayString());
    _persist();
  }

  void updateGoal(int newGoal) {
    if (newGoal <= 0) {
      return;
    }

    final int nextCount = state.count.clamp(0, newGoal);
    state = state.copyWith(
      goal: newGoal,
      count: nextCount,
      lastActiveDate: _todayString(),
    );
    _persist();
  }

  void _persist() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 200), () {
      unawaited(_repository.saveState(state));
    });
  }

  DhikrModel _normalizeForToday(DhikrModel loaded) {
    final String today = _todayString();
    if (loaded.lastActiveDate == today) {
      return loaded;
    }

    final DhikrModel normalized = loaded.copyWith(
      count: 0,
      dailyGlobalCount: 0,
      lastActiveDate: today,
    );
    unawaited(_repository.saveState(normalized));
    return normalized;
  }

  String _todayString() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

class InMemoryDhikrRepository implements DhikrRepository {
  late DhikrModel _state = DhikrModel(
    count: AppConstants.defaultCount,
    dailyGlobalCount: AppConstants.defaultDailyGlobalCount,
    lifetimeCount: AppConstants.defaultDailyGlobalCount,
    goal: AppConstants.defaultGoal,
    currentDhikrIndex: AppConstants.defaultDhikrIndex,
    lastActiveDate: _todayString(),
  );

  String _todayString() {
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
