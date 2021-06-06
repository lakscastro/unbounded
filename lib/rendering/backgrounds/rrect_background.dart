import 'package:flutter/material.dart';

void paintRRectBackground(
  Canvas canvas,
  Size size, {
  required int xCount,
  required int yCount,
  required double spacing,
  required Offset offset,
  required Color color,
}) {
  for (var x = 0; x <= xCount; x++) {
    final paint = Paint()..color = color;

    canvas.drawLine(
      Offset(spacing * x, 0).translate(offset.dx, offset.dy),
      Offset(spacing * x, spacing * yCount).translate(offset.dx, offset.dy),
      paint,
    );
  }

  for (var y = 0; y <= yCount; y++) {
    final paint = Paint()..color = color;

    canvas.drawLine(
      Offset(0, spacing * y).translate(offset.dx, offset.dy),
      Offset(spacing * xCount, spacing * y).translate(offset.dx, offset.dy),
      paint,
    );
  }
}
