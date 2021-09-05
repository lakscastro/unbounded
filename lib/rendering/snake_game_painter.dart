import 'package:flutter/material.dart';
import 'package:unbounded/logic/direction.dart';
import 'package:unbounded/logic/edge.dart';
import 'package:unbounded/logic/snake_node.dart';

class SnakeGamePainter extends CustomPainter {
  final List<SnakeNode> nodes;
  final int xCount;
  final int yCount;
  final double spacing;
  final Offset offset;
  final Color backgroundColor;

  final void Function(
    Canvas canvas,
    Size size, {
    required int xCount,
    required int yCount,
    required double spacing,
    required Offset offset,
    required Color color,
  }) paintBackground;

  const SnakeGamePainter(
    this.nodes, {
    required this.xCount,
    required this.yCount,
    required this.spacing,
    required this.offset,
    required this.paintBackground,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(
      canvas,
      size,
      offset: offset,
      spacing: spacing,
      xCount: xCount,
      yCount: yCount,
      color: backgroundColor,
    );

    final paint = Paint()..color = Colors.greenAccent;

    Direction? _compareNodes(SnakeNode current, SnakeNode adjacent) {
      final isRightToLeft = current.base.x < adjacent.base.x;
      final isLeftToRight = current.base.x > adjacent.base.x;
      final isUpToDown = current.base.y > adjacent.base.y;
      final isDownToUp = current.base.y < adjacent.base.y;

      if (isRightToLeft) return Direction.left;
      if (isLeftToRight) return Direction.right;
      if (isUpToDown) return Direction.down;
      if (isDownToUp) return Direction.up;
    }

    for (var i = 0; i < nodes.length - 1; i++) {
      final current = nodes[i];
      final adjacent = nodes[i + 1];

      final direction = _compareNodes(current, adjacent);

      if (direction == null) continue;

      late Rect rect;

      final handlers = <Direction, VoidCallback>{
        Direction.up: () {
          rect = Rect.fromLTRB(
            current.topLeft.x,
            current.topLeft.y,
            adjacent.bottomRight.x,
            adjacent.bottomRight.y,
          );
        },
        Direction.down: () {
          rect = Rect.fromLTRB(
            adjacent.topLeft.x,
            adjacent.topLeft.y,
            current.bottomRight.x,
            current.bottomRight.y,
          );
        },
        Direction.left: () {
          rect = Rect.fromLTRB(
            current.topLeft.x,
            current.topLeft.y,
            adjacent.topRight.x,
            adjacent.bottomRight.y,
          );
        },
        Direction.right: () {
          rect = Rect.fromLTRB(
            adjacent.topLeft.x,
            adjacent.topLeft.y,
            current.topRight.x,
            current.bottomRight.y,
          );
        },
      };

      handlers[direction]?.call();

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(SnakeGamePainter oldDelegate) => true;
}
