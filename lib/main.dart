import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/src/components/background.dart';
import 'package:unbounded/src/components/overlay_builder.dart';
import 'package:unbounded/src/screens/initial_screen.dart';

import './unbounded.dart';
import './src/services/setup.dart';

Future<void> main() async {
  await GameSetup.init();

  runApp(Root(UnboundedGame()));
}

class Root extends StatelessWidget {
  final Game game;

  const Root(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Background(
        child: InitialScreen(),
      ),
    );

    return GameWidget(
      game: game,
      backgroundBuilder: (context) => const Background(),
      overlayBuilderMap: overlayBuilderMap,
      initialActiveOverlays: const <String>[
        Overlays.menuButtons,
      ],
    );
  }
}
