import 'dart:ui';

import 'package:unbounded/mixins/clonable_mixin.dart';
import 'package:unbounded/logic/direction.dart';
import 'package:unbounded/modules/game_modes/standard/models/standard_snake.dart';
import 'package:unbounded/modules/game_modes/standard/models/standard_snake_node.dart';
import 'package:vector_math/vector_math.dart';

class StandardSnakeGameEngine with ClonableMixin<StandardSnakeGameEngine> {
  /// Data object to handle all snake state's
  ///
  /// Note: A game can have more than one player
  final List<StandardSnake> _snakes;

  /// Data object to handle board state
  final StandardSnake board;

  /// Initial direction of [snake]
  final Direction initialDirection;

  /// Control if game ended or not
  bool gameOver;

  /// Hold all [_snakes] on a ID-based HashMap
  late final snakes = <String, StandardSnake>{
    for (final snake in _snakes) snake.id: snake,
  };

  /// Set all node's directions to [initialDirection]
  /// of all [_snakes]
  late final directions = <String, Map<int, Direction>>{
    for (final snake in _snakes)
      snake.id: <int, Direction>{
        for (var i = 0; i < snake.nodes.length; i++) i: initialDirection,
      },
  };

  late final initialState = this;

  StandardSnakeGameEngine(
    this._snakes, {
    required this.board,
    required this.initialDirection,
    this.gameOver = false,
  });

  Direction directionOf(String snakeId) {
    return snakes[snakeId]!.nodes.first.direction;
  }

  void endGame({bool gameOver}) {
    gameOver = true;
  }

  StandardSnakeGameEngine restart() {
    this = initialState;
    _snakes = 
  }

  void update(double velocity, Direction? nextDirection) {
    if (gameOver) return;

    move(velocity, nextDirection);
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

      handlerWith(direction);

      moveHead(translate());
    } else {
      final adjacent = nodes[index - 1];
      final current = nodes[index];

      final canRemoveLast = <Direction, bool Function()>{
        Direction.left: () => current.topLeft.x <= adjacent.topLeft.x,
        Direction.right: () => current.topRight.x >= adjacent.topRight.x,
        Direction.up: () => current.topLeft.y <= adjacent.topLeft.y,
        Direction.down: () => current.bottomLeft.y >= adjacent.bottomLeft.y,
      };

      handlerWith(current.direction);

      if (canRemoveLast[current.direction]!()) {
        removeLastNode();
        _updateSnakeAt(index - 1, velocity, nextDirection);
      } else {
        moveNode(index, translate());
      }
    }
  }

  @override
  StandardSnakeGameEngine clone() {
    return initialState;
  }
}
