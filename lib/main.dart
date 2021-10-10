import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/src/components/background.dart';
import 'package:unbounded/src/components/menu_carousel.dart';
import 'package:unbounded/src/components/play_button.dart';

import './src/services/setup.dart';
import './unbounded.dart';

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
      home: InitialFlow(),
    );

    // return GameWidget(
    //   game: game,
    //   backgroundBuilder: (context) => const Background(),
    //   overlayBuilderMap: overlayBuilderMap,
    //   initialActiveOverlays: const <String>[
    //     Overlays.menuButtons,
    //   ],
    // );
  }
}

class InitialFlow extends StatefulWidget {
  const InitialFlow({Key? key}) : super(key: key);

  @override
  _InitialFlowState createState() => _InitialFlowState();
}

class _InitialFlowState extends State<InitialFlow> {
  Widget _buildMenu() {
    return const Center(child: PlayButton());
  }

  static const purple = Color(0xFFF72871);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: purple,
        child: Stack(
          children: [
            Positioned.fill(
              child: DottedBackground(
                color: Colors.black.withOpacity(.5),
                size: 5,
                spacing: 0.9,
                child: const MenuCarousel(),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: Background(
    //     child: _showMenu
    //         ? _buildMenu()
    //         : InitialScreen(onEnd: () => setState(() => _showMenu = true)),
    //   ),
    // );
  }
}
