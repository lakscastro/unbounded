import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/unbounded.dart';

class GameScoreOverlay extends StatefulWidget {
  final Game game;

  const GameScoreOverlay(this.game, {Key? key}) : super(key: key);

  @override
  _GameScoreOverlayState createState() => _GameScoreOverlayState();
}

class _GameScoreOverlayState extends State<GameScoreOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('SynthWave Mode'),
          Text('Score 950.0'),
        ],
      ),
    );
  }
}
