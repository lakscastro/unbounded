import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MenuButtonsOverlay extends StatefulWidget {
  final Game game;

  const MenuButtonsOverlay(this.game, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuButtonsOverlayState();
}

class MenuButtonsOverlayState extends State<MenuButtonsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Unbounded',
              style: TextStyle(
                fontFamily: 'RoadRage',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
