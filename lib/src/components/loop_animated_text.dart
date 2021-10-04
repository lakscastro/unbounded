import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoopAnimatedText extends StatefulWidget {
  final Duration delay;
  final String text;
  final Color color;

  const LoopAnimatedText(
    this.text, {
    Key? key,
    this.delay = Duration.zero,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  _LoopAnimatedTextState createState() => _LoopAnimatedTextState();
}

class _LoopAnimatedTextState extends State<LoopAnimatedText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    Timer(widget.delay, () => _controller.repeat(reverse: true));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          widget.text,
          style: TextStyle(
            letterSpacing: 1.2,
            fontFamily: 'Ka1',
            color: widget.color.withOpacity(_opacityAnimation.value / 3),
          ),
        );
      },
    );
  }
}
