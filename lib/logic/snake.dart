import 'dart:ui';

import 'package:unbounded/logic/direction.dart';
import 'package:unbounded/logic/snake_node.dart';
import 'package:vector_math/vector_math.dart';

class Snake {
  final List<SnakeNode> nodes;

  const Snake({required this.nodes});

  Direction? get direction => nodes.first.direction;

  Snake copyWith({List<SnakeNode>? nodes}) {
    return Snake(nodes: nodes ?? this.nodes);
  }

  void moveHead(Vector2 move) {
    moveNode(0, move);
  }

  void moveNode(int index, Vector2 move) {
    nodes[index].base.add(move);
  }

  void removeLastNode() {
    nodes.removeLast();
  }

  void updateNodeDirection(int index, Direction newDirection) {
    nodes[index] = nodes[index].copyWith(direction: newDirection);
  }

  void setDirection(Direction newDirection) {}

  void move(double velocity, Direction? nextDirection) {
    _updateSnakeHead(velocity, nextDirection);
    _updateSnakeBody(velocity, nextDirection);
  }

  void _updateSnakeHead(double velocity, Direction? nextDirection) =>
      _updateSnakeAt(0, velocity, nextDirection);

  void _updateSnakeBody(double velocity, Direction? nextDirection) =>
      _updateSnakeAt(nodes.length - 1, velocity, nextDirection);

  void _updateSnakeAt(int index, double velocity, Direction? nextDirection) {
    var tx = 0.0, ty = 0.0;

    final handler = <Direction, VoidCallback>{
      Direction.up: () => ty = -velocity,
      Direction.down: () => ty = velocity,
      Direction.left: () => tx = -velocity,
      Direction.right: () => tx = velocity,
    };

    void handlerWith(Direction direction) => handler[direction]?.call();

    Vector2 translate() => Vector2(tx, ty);

    if (index == 0) {
      if (nextDirection != null && direction != nextDirection) {
        updateNodeDirection(0, nextDirection);

        nodes.insert(0, nodes.first.copyWith(direction: nextDirection));
      }

      handlerWith(direction!);

      moveHead(translate());
    } else {
      final adjacent = nodes[index - 1];
      final current = nodes[index];

      var none = false;

      if (current.direction == Direction.left) {
        if (current.topLeft.x <= adjacent.topLeft.x) none = true;
      }

      if (current.direction == Direction.right) {
        if (current.topRight.x >= adjacent.topRight.x) none = true;
      }

      if (current.direction == Direction.up) {
        if (current.topLeft.y <= adjacent.topLeft.y) none = true;
      }

      if (current.direction == Direction.down) {
        if (current.bottomLeft.y >= adjacent.bottomLeft.y) none = true;
      }

      handlerWith(current.direction!);

      if (none) {
        removeLastNode();
        _updateSnakeAt(index - 1, velocity, nextDirection);
      } else {
        moveNode(index, translate());
      }
    }
  }
}
