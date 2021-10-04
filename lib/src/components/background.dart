import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final Widget? child;
  final Color color;

  const Background({
    Key? key,
    this.child,
    required this.color,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const DottedBackground(10, 10),
      child: widget.child,
    );
  }
}

class DottedBackground extends CustomPainter {
  final double xCount;
  final double yCount;

  const DottedBackground(this.xCount, this.yCount);

  @override
  void paint(Canvas canvas, Size size) {
    final xSize = size.width / xCount;
    final ySize = size.height / yCount;

    final paint = Paint()..color = Colors.red;
    final dotPaint = Paint()..color = Colors.blue;

    while()

    for (var i = 0.0; i < xCount; i++) {
      for (var j = 0.0; j < yCount; j++) {
        final x = i * xSize;
        final y = j * ySize;

        canvas.drawRect(
          Rect.fromLTWH(x, y, xSize, ySize),
          paint,
        );

        final padding = xSize / 4;

        canvas.drawRect(
          Rect.fromLTWH(
            x + padding,
            y + padding,
            xSize - padding * 2,
            ySize - padding * 2,
          ),
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DottedBackground oldDelegate) {
    return false;
  }
}
