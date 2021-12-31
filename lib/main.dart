import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:unbounded/components/setup.dart';
import 'package:unbounded/widgets/swipe_detector.dart';

Future<void> main() async {
  await setupAll();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SnakeBoard(),
      ),
    );
  }
}

class SnakeBoard extends StatefulWidget {
  const SnakeBoard({Key? key}) : super(key: key);

  @override
  _SnakeBoardState createState() => _SnakeBoardState();
}

class _SnakeBoardState extends State<SnakeBoard>
    with SingleTickerProviderStateMixin {
  static const _kCrossAxisCount = 10;
  static const _kAspectRatio = 1.0;

  static const _kInitialState = SnakeBoardState(
    players: [
      SnakeBoardPlayer(
        player: Player(username: 'lakscastro', avatarUrl: 'my avatar url'),
        parts: [
          SnakeFragment(x: 0, y: 3, direction: Direction.right),
          SnakeFragment(x: 0, y: 2, direction: Direction.bottom),
          SnakeFragment(x: 0, y: 1, direction: Direction.bottom),
          SnakeFragment(x: 0, y: 0, direction: Direction.bottom),
        ],
        nextDirection: Direction.right,
        score: 0,
      ),
      SnakeBoardPlayer(
        player: Player(username: 'satk', avatarUrl: 'avatar url'),
        parts: [
          SnakeFragment(x: 0, y: 8, direction: Direction.left),
          SnakeFragment(x: 0, y: 7, direction: Direction.bottom),
          SnakeFragment(x: 0, y: 6, direction: Direction.bottom),
          SnakeFragment(x: 0, y: 5, direction: Direction.bottom),
        ],
        nextDirection: Direction.left,
        score: 0,
      ),
    ],
    transition: 0,
  );

  late SnakeBoardState _state;

  late final AnimationController _controller;
  late final Animation<double> _transition;

  @override
  void initState() {
    super.initState();

    _state = _kInitialState;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _transition = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _transition.addListener(() {
      if (_transition.status == AnimationStatus.completed) {
        SnakeFragment fragmentMapper(
          SnakeFragment fragment,
          Direction nextDirection,
        ) {
          return fragment.move(nextDirection: nextDirection);
        }

        for (var i = 0; i < _state.players.length; i++) {
          final player = _state.players[i];

          final body = player.parts.skip(1).toList();

          _state = _state.copyWith(
            transition: 0,
            players: [..._state.players]..[i] = player.copyWith(
                parts: [
                  for (var j = player.parts.length - 1; j >= 0; j--)
                    fragmentMapper(
                      player.parts[j],
                      j == 0
                          ? player.nextDirection
                          : player.parts[j - 1].direction,
                    )
                ].reversed.toList(),
              ),
          );

          final newHead = player.parts.first;

          final collision = body.cast<SnakeFragment?>().firstWhere(
                (fragment) =>
                    fragment?.x == newHead.x && fragment?.y == newHead.y,
                orElse: () => null,
              );

          if (collision != null) {
            return _controller.stop();
          }
        }

        _controller.forward(from: 0);
      } else if (_transition.status == AnimationStatus.forward) {
        _state = _state.copyWith(transition: _transition.value);
      }
    });

    _controller.forward(from: 0);
  }

  void _changeDirection(Direction newDirection) {
    if (newDirection.isHorizontal !=
        _state.players[0].parts.first.direction.isHorizontal) {
      _state = _state.copyWith(
        players: [..._state.players]
            .map((player) => player.copyWith(nextDirection: newDirection))
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeDown: () => _changeDirection(Direction.bottom),
      onSwipeUp: () => _changeDirection(Direction.top),
      onSwipeLeft: () => _changeDirection(Direction.left),
      onSwipeRight: () => _changeDirection(Direction.right),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            isComplex: true,
            size: Size.infinite,
            painter: SnakeBoardPainter(
              crossAxisCount: _kCrossAxisCount,
              aspectRatio: _kAspectRatio,
              state: _state,
            ),
          );
        },
      ),
    );
  }
}

enum Direction { top, bottom, left, right }

extension on Direction {
  bool get isVertical => top || bottom;
  bool get isHorizontal => left || right;

  bool get isNegativeDelta => top || left;
  bool get isPositiveDelta => bottom || right;

  bool get top => this == Direction.top;
  bool get bottom => this == Direction.bottom;
  bool get left => this == Direction.left;
  bool get right => this == Direction.right;
}

class SnakeFragment extends Equatable {
  const SnakeFragment({
    required this.x,
    required this.y,
    required this.direction,
  });

  final int x;
  final int y;
  final Direction direction;

  @override
  List<Object> get props => [x, y, direction];

  SnakeFragment copyWith({
    int? x,
    int? y,
    Direction? direction,
  }) {
    return SnakeFragment(
      x: x ?? this.x,
      y: y ?? this.y,
      direction: direction ?? this.direction,
    );
  }

  SnakeFragment move({
    Direction? direction,
    required Direction nextDirection,
  }) {
    direction ??= this.direction;

    final factor = direction.isPositiveDelta ? 1 : -1;
    final base = direction.isHorizontal ? x : y;

    final updated = direction.isHorizontal
        ? copyWith(x: base + factor)
        : copyWith(y: base + factor);

    return updated.copyWith(direction: nextDirection);
  }
}

class Player extends Equatable {
  const Player({
    required this.username,
    required this.avatarUrl,
  });

  final String username;
  final String avatarUrl;

  @override
  List<Object> get props => [username, avatarUrl];

  Player copyWith({
    String? username,
    String? avatarUrl,
  }) {
    return Player(
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class SnakeBoardPlayer extends Equatable {
  const SnakeBoardPlayer({
    required this.player,
    required this.parts,
    required this.nextDirection,
    required this.score,
  });

  final Player player;
  final List<SnakeFragment> parts;
  final Direction nextDirection;
  final int score;

  SnakeBoardPlayer copyWith({
    Player? player,
    List<SnakeFragment>? parts,
    Direction? nextDirection,
    int? score,
  }) {
    return SnakeBoardPlayer(
      player: player ?? this.player,
      parts: parts ?? this.parts,
      nextDirection: nextDirection ?? this.nextDirection,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [player, nextDirection, ...parts, score];
}

class SnakeBoardState extends Equatable {
  const SnakeBoardState({required this.players, required this.transition});

  final List<SnakeBoardPlayer> players;
  final double transition;

  @override
  List<Object> get props => [transition, ...players];

  SnakeBoardState copyWith({
    List<SnakeBoardPlayer>? players,
    double? transition,
  }) {
    return SnakeBoardState(
      players: players ?? this.players,
      transition: transition ?? this.transition,
    );
  }
}

class SnakeBoardPainter extends CustomPainter {
  SnakeBoardPainter({
    required this.crossAxisCount,
    required this.aspectRatio,
    required this.state,
  });

  static const _kBorder = 10.0;

  final int crossAxisCount;
  final double aspectRatio;
  final SnakeBoardState state;

  /// Canvas instance
  late Canvas _canvas;

  /// Canvas size
  late Size __size;

  Paint get _borderPaint => Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = _kBorder;

  Paint get _dividerPaint => _borderPaint
    ..strokeWidth = _kBorder / 10
    ..color = Colors.blue;

  Offset get _offset {
    return Offset(__size.width - _boardWidth, __size.height - _boardHeight);
  }

  void _startPaintingAsBoard() {
    _canvas.save();

    _canvas.translate(_offset.dx / 2, _offset.dy / 2);
  }

  void _stopPaintingAsBoard() {
    _canvas.restore();
  }

  void _paintBackground() {
    _canvas.drawRect(
      Rect.fromLTWH(0, 0, __size.width, __size.height),
      _borderPaint..strokeWidth = 1,
    );

    _startPaintingAsBoard();

    _drawColumns();
    _drawRows();

    _stopPaintingAsBoard();
  }

  void _drawColumns() {
    for (var i = 1; i < crossAxisCount; i++) {
      _canvas.drawLine(
        Offset(i * _unitWidth, 0),
        Offset(i * _unitWidth, _boardHeight),
        _dividerPaint,
      );
    }
  }

  void _drawRows() {
    for (var i = 1; i < _mainAxisCount; i++) {
      _canvas.drawLine(
        Offset(0, i * _unitHeight),
        Offset(_boardWidth, i * _unitHeight),
        _dividerPaint,
      );
    }
  }

  void _drawSnakeFragment(SnakeFragment part, double progress) {
    final x = part.x % crossAxisCount;
    final y = part.y % _mainAxisCount;

    final direction = part.direction;

    final axis = direction.isHorizontal ? x : y;
    final bounds = direction.isHorizontal ? crossAxisCount : _mainAxisCount;

    final overflowed =
        direction.isPositiveDelta ? axis >= bounds - 1 : axis <= 0;

    final isHorizontal = direction.isHorizontal;

    final transition = progress * (isHorizontal ? _unitWidth : _unitHeight);

    final painterHandlers = <Direction, void Function()>{
      Direction.top: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitWidth,
            y * _unitHeight - (overflowed ? 0 : transition),
            _unitWidth,
            _unitHeight - (overflowed ? transition : 0),
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.bottom: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitWidth,
            y * _unitHeight + transition,
            _unitWidth,
            _unitHeight - (overflowed ? transition : 0),
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.left: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitWidth - (overflowed ? 0 : transition),
            y * _unitHeight,
            _unitWidth - (overflowed ? transition : 0),
            _unitHeight,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.right: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitWidth + transition,
            y * _unitHeight,
            _unitWidth - (overflowed ? transition : 0),
            _unitHeight,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
    };

    final overflowHandlers = <Direction, void Function()>{
      Direction.top: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitHeight,
            _boardHeight - transition,
            _unitWidth,
            transition,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.bottom: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            x * _unitHeight,
            0,
            _unitWidth,
            transition,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.left: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            _boardWidth - transition,
            y * _unitHeight,
            transition,
            _unitHeight,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
      Direction.right: () {
        _canvas.drawRect(
          Rect.fromLTWH(
            0,
            y * _unitHeight,
            transition,
            _unitHeight,
          ),
          _borderPaint..style = PaintingStyle.fill,
        );
      },
    };

    painterHandlers[direction]!();

    if (overflowed) {
      overflowHandlers[direction]!();
    }
  }

  void _paintSnake() {
    _startPaintingAsBoard();

    for (var i = 0; i < state.players.length; i++) {
      final player = state.players[i];

      for (var j = 0; j < player.parts.length; j++) {
        final parts = player.parts;
        final part = parts[j];

        if (j < parts.length - 1) {
          _drawSnakeFragment(part, 0);
        }

        _drawSnakeFragment(part, state.transition);
      }
    }

    _stopPaintingAsBoard();
  }

  double get _unitWidth => __size.width / crossAxisCount;
  double get _unitHeight => _unitWidth * aspectRatio;
  int get _mainAxisCount => __size.height ~/ _unitHeight;
  double get _boardHeight => _mainAxisCount * _unitHeight;
  double get _boardWidth => crossAxisCount * _unitWidth;

  void _calcVariables() {}

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    __size = size;

    _calcVariables();
    _paintBackground();
    _paintSnake();
  }

  @override
  bool shouldRepaint(SnakeBoardPainter oldDelegate) =>
      oldDelegate.state != state;
}
