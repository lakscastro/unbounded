import 'package:flutter/cupertino.dart';

void paintRoundedBackground(
  Canvas canvas,
  Size size, {
  required int xCount,
  required int yCount,
  required double spacing,
  required Offset offset,
  required Color color,
}) {
  final da = Offset(offset.dx, offset.dy);
  final db = Offset(xCount * spacing + offset.dx, yCount * spacing + offset.dy);

  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color;

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(da.dx, da.dy, db.dx, db.dy),
      Radius.circular(10),
    ),
    paint,
  );

  for (var x = 1; x < xCount; x++) {
    final paint = Paint()..color = color;

    canvas.drawLine(
      Offset(spacing * x, 0).translate(offset.dx, offset.dy),
      Offset(spacing * x, spacing * yCount).translate(offset.dx, offset.dy),
      paint,
    );
  }

  for (var y = 1; y < yCount; y++) {
    final paint = Paint()..color = color;

    canvas.drawLine(
      Offset(0, spacing * y).translate(offset.dx, offset.dy),
      Offset(spacing * xCount, spacing * y).translate(offset.dx, offset.dy),
      paint,
    );
  }
}
