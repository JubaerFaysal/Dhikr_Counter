import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 46 : 50,
      height: compact ? 46 : 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2D2E34)),
        color: const Color(0xFF0D1015),
      ),
      child: const Icon(
        Icons.chevron_left_rounded,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}