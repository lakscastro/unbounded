import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/src/constants/padding.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kButtonSize = 200.0;

  static const purple = Color(0xFFF72871);
  static const secondary = Color(0xFF160001);

  late AnimationController _mainButtonAnimation;

  late Animation<double> _heightMainButtonAnimation;
  late Animation<double> _floatingAnimation;

  late AnimationController _splashButtonAnimation;

  late Animation<double> _transitionAnimation;

  @override
  void initState() {
    super.initState();

    _mainButtonAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 1,
      lowerBound: 0,
    );

    _splashButtonAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    _transitionAnimation = CurvedAnimation(
      parent: _splashButtonAnimation,
      curve: Curves.easeInOut,
    );

    _mainButtonAnimation.addListener(_mainAnimationListener);
  }

  var _triggered = false;

  double? _diameter;

  void _mainAnimationListener() {
    if (_mainButtonAnimation.value == 1) {
      _triggered = true;

      final a = MediaQuery.of(context).size.height;

      final b = MediaQuery.of(context).size.width;

      _diameter = sqrt(pow(a, 2) + pow(b, 2));

      _splashButtonAnimation.forward();
    }
  }

  @override
  void dispose() {
    _mainButtonAnimation.dispose();

    super.dispose();
  }

  Widget _buildPlayButton() {
    return AnimatedBuilder(
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
              _mainButtonAnimation.forward(from: _mainButtonAnimation.value);
            },
            onPointerUp: (details) {
              if (_triggered) return;

              _mainButtonAnimation.reverse(from: _mainButtonAnimation.value);
            },
            child: Stack(
              children: [
                _buildAnimatedFillBackground(),
                _buildFilledCircle(),
                _buildPlayOutlineCircle(),
                _buildPlayIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashAnimatedBackground() {
    return Center(
      child: AnimatedBuilder(
        animation: _splashButtonAnimation,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            width: 2000,
            height: 2000,
            // width: _diameter! * _splashButtonAnimation.value,
            // height: _diameter! * _splashButtonAnimation.value,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedFillBackground() {
    return Center(
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
                  spreadRadius: 10 + _heightMainButtonAnimation.value * 10,
                  blurRadius: 150 + _heightMainButtonAnimation.value * 150,
                  color: Color.lerp(
                    secondary.withOpacity(.54),
                    purple.withOpacity(.54),
                    _heightMainButtonAnimation.value,
                  )!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilledCircle() {
    return Center(
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
                  height: _kButtonSize * _heightMainButtonAnimation.value,
                  decoration: const BoxDecoration(color: purple),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayOutlineCircle() {
    return Center(
      child: AnimatedBuilder(
        animation: _mainButtonAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorTween(begin: purple, end: secondary)
                    .evaluate(_heightMainButtonAnimation)!,
                width: 4,
              ),
            ),
            width: _kButtonSize,
            height: _kButtonSize,
          );
        },
      ),
    );
  }

  Widget _buildPlayIcon() {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: _mainButtonAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: pi * 0.5 * _heightMainButtonAnimation.value,
              child: Icon(
                Icons.play_arrow_outlined,
                color: ColorTween(begin: purple, end: secondary)
                    .evaluate(_heightMainButtonAnimation),
                size: 120,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildPlayButton(),
        Positioned.fill(
          child: Center(
            child: AnimatedBuilder(
              animation: _splashButtonAnimation,
              builder: (context, child) {
                if (_diameter == null) return Container();

                return CustomPaint(
                  painter: Transition(_transitionAnimation.value * _diameter!),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Transition extends CustomPainter {
  final double radius;

  const Transition(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    canvas.drawCircle(center, radius, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(Transition oldDelegate) => oldDelegate.radius != radius;
}
