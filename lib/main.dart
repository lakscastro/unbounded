import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/src/components/background.dart';
import 'package:unbounded/src/components/loop_animated_text.dart';
import 'package:unbounded/src/constants/padding.dart';

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

class _InitialFlowState extends State<InitialFlow>
    with TickerProviderStateMixin {
  var _showMenu = false;

  static const _kButtonSize = 200.0;

  static const purple = Color(0xFFF72871);
  static const secondary = Color(0xFF160001);

  Widget _buildSquare(String text, Color color, int level) {
    return Container(
      padding: const EdgeInsets.all(k2dp),
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: k8dp,
            horizontal: k16dp,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF000000),
              fontFamily: 'Road_Rage',
            ),
          ),
        ),
      ),
    );
  }

  late AnimationController _mainButtonAnimation;

  late Animation<double> _heightMainButtonAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _mainButtonAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1,
      lowerBound: 0,
    );

    _heightMainButtonAnimation = CurvedAnimation(
      parent: _mainButtonAnimation,
      curve: Curves.easeInOut,
    );

    _floatingAnimation = CurvedAnimation(
      parent: _mainButtonAnimation,
      curve: Curves.easeInOutQuad,
    );
  }

  Widget _buildMenu() {
    return Center(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _mainButtonAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Background(
                  color: Color.lerp(
                      purple, secondary, _heightMainButtonAnimation.value)!,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _mainButtonAnimation,
            builder: (context, child) => Padding(
              padding: EdgeInsets.only(top: _floatingAnimation.value * k10dp),
              child: child,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Listener(
                  onPointerDown: (details) {
                    _mainButtonAnimation.forward(
                        from: _mainButtonAnimation.value);
                  },
                  onPointerUp: (details) {
                    _mainButtonAnimation.reverse(
                        from: _mainButtonAnimation.value);
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedBuilder(
                          animation: _mainButtonAnimation,
                          builder: (context, child) {
                            return Container(
                              width: _kButtonSize,
                              height: _kButtonSize,
                              decoration: BoxDecoration(
                                color: secondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 10 +
                                        _heightMainButtonAnimation.value * 10,
                                    blurRadius: 150 +
                                        _heightMainButtonAnimation.value * 150,
                                    color: Color.lerp(
                                        secondary.withOpacity(.54),
                                        purple.withOpacity(.54),
                                        _heightMainButtonAnimation.value)!,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                        child: ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: _kButtonSize,
                            height: _kButtonSize,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedBuilder(
                                animation: _mainButtonAnimation,
                                builder: (context, child) {
                                  return Container(
                                    width: _kButtonSize,
                                    height: _kButtonSize *
                                        _heightMainButtonAnimation.value,
                                    decoration: BoxDecoration(
                                      color: purple,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: _mainButtonAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorTween(
                                          begin: purple, end: secondary)
                                      .evaluate(_heightMainButtonAnimation)!,
                                  width: 4,
                                ),
                              ),
                              width: _kButtonSize,
                              height: _kButtonSize,
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _mainButtonAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle:
                                    pi * 0.5 * _heightMainButtonAnimation.value,
                                child: Icon(
                                  Icons.play_arrow_outlined,
                                  color:
                                      ColorTween(begin: purple, end: secondary)
                                          .evaluate(_heightMainButtonAnimation),
                                  size: 120,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(k16dp),
                      child: LoopAnimatedText(
                        'HOLD TO CONTINUE',
                        color: secondary,
                      ),
                    ),
                    // ActionButton(text: 'Settings'),
                    // Divider(color: Colors.transparent),
                    // ActionButton(text: 'Rate'),
                    // Divider(color: Colors.transparent),
                    // ActionButton(text: 'Contribute'),
                    // Divider(color: Colors.transparent),
                    // ActionButton(text: 'Credits'),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: secondary,
        child: _buildMenu(),
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
