import 'dart:ui';

import 'package:unbounded/interface/immutable.dart';
import 'package:unbounded/logic/direction.dart';
import 'package:unbounded/logic/edge.dart';
import 'package:vector_math/vector_math.dart';

class StandardSnakeNode implements Clonable {
  final Vector2 base;
  final Color color;
  final Size size;
  final Direction direction;

  const StandardSnakeNode({
    required this.base,
    required this.color,
    required this.size,
    required this.direction,
  });

  Vector2 get topLeft => base;
  Vector2 get topRight => base.clone()..add(Vector2(size.width, 0));
  Vector2 get bottomLeft => base.clone()..add(Vector2(0, size.height));
  Vector2 get bottomRight =>
      base.clone()..add(Vector2(size.width, size.height));

  Edge get topLeft2TopRight => Edge(a: topLeft, b: topRight);
  Edge get topLeft2BottomLeft => Edge(a: topLeft, b: bottomLeft);
  Edge get bottomLeft2BottomRight => Edge(a: bottomLeft, b: bottomRight);
  Edge get topRight2BottomRight => Edge(a: topRight, b: bottomRight);

  List<Edge> get edges => [
        topLeft2TopRight,
        topLeft2BottomLeft,
        bottomLeft2BottomRight,
        topRight2BottomRight,
      ];

  StandardSnakeNode copyWith({
    Vector2? base,
    Color? color,
    Size? size,
    Direction? direction,
  }) {
    return StandardSnakeNode(
      base: base ?? this.base.clone(),
      color: color ?? Color(this.color.value),
      size: size ?? Size(this.size.width, this.size.height),
      direction: direction ?? this.direction,
    );
  }

  @override
  StandardSnakeNode clone() {
    return StandardSnakeNode(
      base: base.clone(),
      color: Color(color.value),
      size: Size(size.width, size.height),
      direction: direction,
    );
  }
}
