import 'dart:ui';

import 'package:unbounded/interface/immutable.dart';
import 'package:unbounded/modules/game_modes/standard/models/standard_snake_node.dart';
import 'package:vector_math/vector_math.dart';

class StandardSnake implements Clonable<StandardSnake> {
  final String id;
  final List<StandardSnakeNode> nodes;

  const StandardSnake({required this.id, required this.nodes});

  StandardSnake copyWith({
    List<StandardSnakeNode>? nodes,
    bool? gameOver,
    String? id,
  }) {
    return StandardSnake(
      id: id ?? this.id,
      nodes: nodes ?? this.nodes,
    );
  }

  @override
  StandardSnake clone() {
    return StandardSnake(
      id: id,
      nodes: [
        ...nodes.map((n) => n.clone()).toList(),
      ],
    );
  }

  StandardSnake removeLastNode() {
    return clone().._removeLastNode();
  }

  StandardSnake moveHead(Vector2 move) {
    return clone().._moveNode(0, move);
  }

  void _moveNode(int index, Vector2 move) {
    nodes[index].base.add(move);
  }

  void _removeLastNode() {
    nodes.removeLast();
  }
}
