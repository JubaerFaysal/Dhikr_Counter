class DhikrPhraseModel {
  const DhikrPhraseModel({
    required this.arabic,
    required this.english,
    required this.meaning,
  });

  final String arabic;
  final String english;
  final String meaning;
}

class DhikrModel {
  const DhikrModel({
    required this.count,
    required this.dailyGlobalCount,
    required this.lifetimeCount,
    required this.goal,
    required this.currentDhikrIndex,
    required this.lastActiveDate,
  });

  final int count;
  final int dailyGlobalCount;
  final int lifetimeCount;
  final int goal;
  final int currentDhikrIndex;
  final String lastActiveDate;

  double get progress => (count / goal).clamp(0, 1).toDouble();

  DhikrModel copyWith({
    int? count,
    int? dailyGlobalCount,
    int? lifetimeCount,
    int? goal,
    int? currentDhikrIndex,
    String? lastActiveDate,
  }) {
    return DhikrModel(
      count: count ?? this.count,
      dailyGlobalCount: dailyGlobalCount ?? this.dailyGlobalCount,
      lifetimeCount: lifetimeCount ?? this.lifetimeCount,
      goal: goal ?? this.goal,
      currentDhikrIndex: currentDhikrIndex ?? this.currentDhikrIndex,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
