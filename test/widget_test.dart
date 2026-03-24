import 'package:dhikr_counter/main.dart';
import 'package:dhikr_counter/features/dhikr/presentation/providers/dhikr_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dhikr recite increments count', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2200));
    addTearDown(() async => tester.binding.setSurfaceSize(null));

    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );

    expect(find.text('Dhikr'), findsOneWidget);
    final int initialCount = container.read(dhikrViewModelProvider).count;

    await tester.tap(find.text('SUBHANALLAH'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(container.read(dhikrViewModelProvider).count, initialCount + 1);
  });
}
