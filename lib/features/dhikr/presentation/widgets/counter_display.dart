import 'package:dhikr_counter/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    super.key,
    required this.dailyGlobalCount,
    required this.compact,
  });

  final int dailyGlobalCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF3A3220)),
              color: const Color(0xFF0B0D11),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.circle, size: 10, color: Color(0xFF10B981)),
                SizedBox(width: 10),
                Text(
                  'GLOBAL LIVE COUNT',
                  style: TextStyle(
                    color: Color(0xFFB79B43),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          formatWithCommas(dailyGlobalCount),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 30 : 38,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'TOTAL RECITATIONS TODAY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB79B43),
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
