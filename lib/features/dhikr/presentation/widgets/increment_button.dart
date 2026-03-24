import 'package:dhikr_counter/features/dhikr/data/models/dhikr_model.dart';
import 'package:flutter/material.dart';

class IncrementButton extends StatelessWidget {
  const IncrementButton({
    super.key,
    required this.orbSize,
    required this.phrase,
    required this.count,
    required this.onTap,
  });

  final double orbSize;
  final DhikrPhraseModel phrase;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: orbSize,
          height: orbSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF5B4A1A), width: 1.5),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x33D2B44F),
                blurRadius: 28,
                spreadRadius: 10,
              ),
            ],
            gradient: const RadialGradient(
              colors: <Color>[
                Color(0xFF090A0F),
                Color(0xFF050608),
                Color(0xFF030303),
              ],
              stops: <double>[0, 0.5, 1],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    phrase.arabic,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFD3B859),
                      fontSize: orbSize * 0.120,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phrase.english,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: orbSize * 0.09,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phrase.meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF7B7E86),
                      fontSize: orbSize * 0.048,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$count',
                    style: TextStyle(
                      color: const Color(0xFFCCCDD4),
                      fontSize: orbSize * 0.13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
