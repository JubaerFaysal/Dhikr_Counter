import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showGoalPickerBottomSheet({
  required BuildContext context,
  required List<int> presets,
  required ValueChanged<int> onGoalSelected,
}) async {
  final BuildContext parentContext = context;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF111318),
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Set Session Goal',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presets
                    .map(
                      (int goal) => FilledButton.tonal(
                        onPressed: () {
                          onGoalSelected(goal);
                          Navigator.of(sheetContext).pop();
                        },
                        child: Text('$goal'),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  await Future<void>.delayed(Duration.zero);
                  if (!parentContext.mounted) {
                    return;
                  }

                  await _showCustomGoalDialog(
                    context: parentContext,
                    onGoalSelected: onGoalSelected,
                  );
                },
                child: const Text('Custom goal'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showCustomGoalDialog({
  required BuildContext context,
  required ValueChanged<int> onGoalSelected,
}) async {
  int? parsedValue;

  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(VoidCallback) setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF121317),
            title: const Text(
              'Custom Goal',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  final int? input = int.tryParse(value);
                  parsedValue = (input != null && input > 0) ? input : null;
                });
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(hintText: 'Enter a number'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: parsedValue == null
                    ? null
                    : () {
                        onGoalSelected(parsedValue!);
                        Navigator.of(dialogContext).pop();
                      },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
