import 'package:unbounded/logic/grid.dart';

/// Converts a **matrix-based** GameBoard to **any
/// context**, like a:
/// - Screen (cartesian points)
/// - Terminal (relative matrix)
/// - Anything else
abstract class ContextAdapter {
  GameBoard get indexBasedBoard;
  GameBoard get outputBoard;
}

/// Convert a **matrix-based** board (let x & y as matrix-indexes)
/// to a screen (let x & y as cartesian points)
class ScreenAdapter extends ContextAdapter {
  @override
  GameBoard get indexBasedBoard => throw UnimplementedError();

  @override
  GameBoard get outputBoard => throw UnimplementedError();
}
