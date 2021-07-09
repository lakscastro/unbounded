import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/config/game_config.dart';
import 'package:unbounded/logic/direction.dart';
import 'package:unbounded/logic/snake_node.dart';
import 'package:unbounded/mixins/query_mixin.dart';
import 'package:unbounded/modules/game_modes/standard/models/standard_snake.dart';
import 'package:unbounded/rendering/backgrounds/classic_theme.dart';
import 'package:unbounded/rendering/snake_game_painter.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'package:unbounded/logic/grid.dart';
import 'package:unbounded/widgets/swipe_detector.dart';

class SnakeGameScreen extends StatefulWidget {
  final GameConfig config;

  const SnakeGameScreen({Key? key, required this.config}) : super(key: key);

  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen>
    with SingleTickerProviderStateMixin, QueryMixin {
  var _freezeSnake = true;

  Direction? _nextDirection;

  late GameBoard _grid;
  late StandardSnake _snake;
  late Animation<double> _animation;
  late AnimationController _controller;

  double get _velocity => widget.config.velocity;

  void _setSnakeDirection(Direction newDirection) {
    _setSnakeStatus(freeze: false);

    if (!_canMoveTo(_snake.direction, newDirection)) return;

    _nextDirection = newDirection;
  }

  bool _canMoveTo(Direction currentDirection, Direction newDirection) {
    final leftOrRight = <Direction>{Direction.left, Direction.right};
    final upOrDown = <Direction>{Direction.up, Direction.down};

    final validMoves = <Direction, Set<Direction>>{
      Direction.up: leftOrRight,
      Direction.down: leftOrRight,
      Direction.left: upOrDown,
      Direction.right: upOrDown,
    };

    return validMoves[currentDirection]!.contains(newDirection);
  }

  void _setSnakeStatus({required bool freeze}) {
    _freezeSnake = freeze;
  }

  @override
  void initState() {
    super.initState();

    _initController();
    _initAnimation();
    _initGame();
  }

  @override
  void didChangeDependencies() {
    _initGrid();
    _initSnake();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _disposeController();

    super.dispose();
  }

  void _disposeController() {
    _controller.dispose();
  }

  void _initGrid() {
    _grid = GameBoard(
      width: deviceWidth,
      height: deviceHeight,
      columnsCount: 15,
      padding: EdgeInsets.all(10),
      threshold: 0.05,
    );
  }

  void _initSnake() {
    final size = Size.square(_grid.spacing);

    final nodes = <SnakeNode>[
      SnakeNode(
        base: _grid.center,
        color: Colors.blue,
        size: size,
        direction: Direction.up,
      ),
    ];

    nodes.add(
      nodes.first.copyWith(
        base: Vector2(
          nodes.first.base.x,
          _grid.centerY + _grid.spacing * 7,
        ),
      ),
    );

    _snake = Snake(id: 'player-1', nodes: nodes);
  }

  void _initController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
  }

  void _initAnimation() {
    _animation = Tween<double>().animate(_controller);
  }

  void _initGame() {
    _controller.addListener(_mainGameLoop);

    _controller.repeat();
  }

  void _mainGameLoop() {
    if (_freezeSnake) return;

    _snake.move(_velocity, _nextDirection);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => CustomPaint(
        painter: SnakeGamePainter(
          _snake.nodes,
          spacing: _grid.spacing,
          xCount: _grid.columnsCount,
          yCount: _grid.rowsCount,
          offset: _grid.offset,
          paintBackground: classicTheme,
          backgroundColor:
              HSLColor.fromColor(Colors.red).withLightness(0.2).toColor(),
        ),
        willChange: true,
        child: SwipeDetector(
          onSwipeUp: (_) => _setSnakeDirection(Direction.up),
          onSwipeDown: (_) => _setSnakeDirection(Direction.down),
          onSwipeLeft: (_) => _setSnakeDirection(Direction.left),
          onSwipeRight: (_) => _setSnakeDirection(Direction.right),
        ),
      ),
    );
  }
}
