import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/config/game_config.dart';
import 'package:unbounded/mixins/theme_mixin.dart';
import 'package:unbounded/screens/snake_game/snake_game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SnakeGameScreen(
              config: GameConfig(velocity: 5),
            ),
          ),
        ],
      ),
    );
  }
}
