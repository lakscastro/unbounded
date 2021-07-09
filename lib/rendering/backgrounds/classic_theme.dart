import 'package:flutter/material.dart';

void classicTheme(
  Canvas canvas,
  Size size, {
  required int xCount,
  required int yCount,
  required double spacing,
  required Offset offset,
  required Color color,
}) {
  final backgroundPaint = Paint()..color = Color(0xFFA9B391);

  canvas.drawRect(
    Rect.fromLTRB(0, 0, size.width, size.height),
    backgroundPaint,
  );

  for (var x = 0; x < xCount; x++) {
    for (var y = 0; y < yCount; y++) {
      final paint = Paint()..color = Color(0xFFC4D0A3);

      const padding = 1.2;

      canvas.drawRect(
        Rect.fromLTRB(
          spacing * x + padding,
          spacing * y + padding,
          spacing * x + spacing - padding,
          spacing * y + spacing - padding,
        ).translate(
          offset.dx,
          offset.dy,
        ),
        paint,
      );
    }
  }
}
