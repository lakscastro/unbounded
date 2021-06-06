import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math.dart';

class Grid {
  final double width;
  final double height;

  double get realWidth => width - padding.left - padding.right;
  double get realHeight => height - padding.top - padding.top;

  final int columnsCount;

  final bool forceSquare;
  final bool centralize;

  final double threshold;
  final EdgeInsets padding;

  const Grid({
    required this.width,
    required this.height,
    required this.columnsCount,
    this.threshold = 0.05,
    this.forceSquare = false,
    this.centralize = true,
    this.padding = EdgeInsets.zero,
  });

  bool canChange(double x, double y) {
    final xIsInLimit = (x - offsetX).ceil() % spacing <= threshold;
    final yIsInLimit = (y - offsetY).ceil() % spacing <= threshold;

    return xIsInLimit && yIsInLimit;
  }

  Vector2 get center {
    return Vector2(centerX, centerY);
  }

  double get centerX {
    final x = realWidth / 2;

    return (x - x % spacing) + offsetX;
  }

  double get centerY {
    final y = realHeight / 2;

    return (y - y % spacing) + offsetY;
  }

  int get rowsCount {
    return realHeight ~/ spacing;
  }

  double get spacing {
    return realWidth / columnsCount;
  }

  double get offsetX => offset.dx;
  double get offsetY => offset.dy;

  Offset get offset {
    final diffX = width - _width;
    final diffY = height - _height;

    return Offset(diffX / 2, diffY / 2);
  }

  double get _width => columnsCount * spacing;
  double get _height => rowsCount * spacing;
}
