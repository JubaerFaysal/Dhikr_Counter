import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:dhikr_counter/features/dhikr/presentation/providers/dhikr_provider.dart';
import 'package:dhikr_counter/features/dhikr/presentation/widgets/circle_button.dart';
import 'package:dhikr_counter/features/dhikr/presentation/widgets/counter_display.dart';
import 'package:dhikr_counter/features/dhikr/presentation/widgets/goal_picker.dart';
import 'package:dhikr_counter/features/dhikr/presentation/widgets/increment_button.dart';
import 'package:dhikr_counter/features/dhikr/presentation/widgets/reset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DhikrScreen extends ConsumerWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DhikrModel state = ref.watch(dhikrViewModelProvider);
    final DhikrViewModel viewModel = ref.read(dhikrViewModelProvider.notifier);
    final DhikrPhraseModel phrase = viewModel.phrases[state.currentDhikrIndex];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final bool compact = width < 380;
            final double orbSize = width * 0.66;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleButton(compact: compact),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Dhikr',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: compact ? 24 : 26,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'JOINED',
                              style: TextStyle(
                                color: Color(0xFFB79B43),
                                letterSpacing: 2,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CounterDisplay(
                      dailyGlobalCount: state.dailyGlobalCount,
                      compact: compact,
                    ),
                    const SizedBox(height: 34),
                    IncrementButton(
                      orbSize: orbSize,
                      phrase: phrase,
                      count: state.count,
                      onTap: viewModel.recite,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'TAP TO RECITE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8E9098),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: FilledButton.tonal(
                        onPressed: viewModel.switchDhikr,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3A3220),
                          foregroundColor: const Color(0xFFD3B859),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          '⇄  CHANGE RECITE',
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'SESSION GOAL',
                      style: TextStyle(
                        color: Color(0xFF7D7E86),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${state.count} / ${state.goal}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            IconButton(
                              onPressed: () => goalPickerBottomSheet(
                                context: context,
                                presets: DhikrViewModel.goalPresets,
                                onGoalSelected: viewModel.updateGoal,
                              ),
                              icon: const Icon(Icons.edit_rounded),
                              color: const Color(0xFFD2B44F),
                              tooltip: 'Edit goal',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'LIFETIME: ${state.lifetimeCount}',
                              style: const TextStyle(
                                color: Color(0xFF8E9098),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${(state.progress * 100).round()}% COMPLETE',
                              style: const TextStyle(
                                color: Color(0xFFD2B44F),
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: state.progress,
                        backgroundColor: const Color(0xFF24252B),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFD2B44F),
                        ),
                      ),
                    ),
                    ResetButton(onPressed: viewModel.resetSession),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
