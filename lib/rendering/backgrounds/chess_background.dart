import 'package:flutter/material.dart';

void paintChessBackground(
  Canvas canvas,
  Size size, {
  required int xCount,
  required int yCount,
  required double spacing,
  required Offset offset,
  required Color color,
}) {
  for (var x = 0; x < xCount; x++) {
    for (var y = 0; y < yCount; y++) {
      final a = Color(0xFF7D4DFA);
      final b = Color(0xFF7D4DFA).withOpacity(.3);

      final color = (y - (x % 2)) % 2 == 0 ? a : b;

      final paint = Paint()..color = color;

      canvas.drawRect(
        Rect.fromLTRB(
          spacing * x,
          spacing * y,
          spacing * x + spacing,
          spacing * y + spacing,
        ).translate(
          offset.dx,
          offset.dy,
        ),
        paint,
      );
    }
  }
}
