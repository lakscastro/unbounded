import 'dart:math';

import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  final VoidCallback onEnd;

  const InitialScreen({Key? key, required this.onEnd}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _AnimatedStringConfiguration {
  final String text;
  final List<Color> colors;
  final ProgressMode progressMode;

  const _AnimatedStringConfiguration({
    required this.text,
    required this.colors,
    required this.progressMode,
  });

  _AnimatedStringConfiguration.singleColor({
    required this.text,
    required Color color,
    required this.progressMode,
  }) : colors = List<Color>.filled(text.length, color);
}

class _InitialScreenState extends State<InitialScreen> {
  static const _text = 'Unbounded';

  static final _texts = <_AnimatedStringConfiguration>[
    _AnimatedStringConfiguration.singleColor(
      text: _text,
      color: Colors.redAccent,
      progressMode: ProgressMode.linear,
    ),
  ];

  int _current = 0;

  double _opacity = 1;

  void _showNextString() async {
    if (_current == _texts.length - 1) {
      await Future.delayed(const Duration(seconds: 1));
      return setState(() => _opacity = 0);
    } else {
      setState(() => _current++);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _opacity,
        onEnd: widget.onEnd,
        curve: Curves.easeInOutQuint,
        child: Stack(
          children: <Widget>[
            for (var i = 0; i <= _current; i++)
              Positioned.fill(
                top: i * 3,
                left: i * 3,
                child: _AnimatedString(
                  text: _texts[i].text,
                  onComplete: i == _current ? _showNextString : null,
                  colorOf: (index) => _texts[i].colors[index],
                  progressMode: _texts[i].progressMode,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedString extends StatefulWidget {
  final String text;
  final VoidCallback? onComplete;
  final ProgressMode progressMode;
  final Color Function(int)? colorOf;

  const _AnimatedString({
    Key? key,
    required this.text,
    this.onComplete,
    this.progressMode = ProgressMode.linear,
    this.colorOf,
  }) : super(key: key);

  @override
  _AnimatedStringState createState() => _AnimatedStringState();
}

enum ProgressMode {
  linear,
  parallel,
  random,
}

class _AnimatedStringState extends State<_AnimatedString> {
  late final List<String> _chars = widget.text.split('');
  late final List<int> _isVisibleOrNot = List<int>.filled(_chars.length, 0);

  void _showNextChar(VoidCallback nextState) {
    setState(() => nextState());
  }

  void _nextLinear() {
    final index = _isVisibleOrNot.indexWhere((state) => state == 0);
    if (index == -1) {
      if (widget.onComplete != null) widget.onComplete!();
    } else {
      _isVisibleOrNot[index] = 1;
    }
  }

  void _nextParallel() {
    if (_isVisibleOrNot.any((state) => state == 0)) {
      _isVisibleOrNot.fillRange(0, _isVisibleOrNot.length, 1);
    } else if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void _nextRandom() {
    final available = <int>[];

    for (var i = 0; i < _isVisibleOrNot.length; i++) {
      if (_isVisibleOrNot[i] == 0) {
        available.add(i);
      }
    }

    if (available.isNotEmpty) {
      int randomInt() => Random().nextInt(available.length);
      final next = available[randomInt()];
      _isVisibleOrNot[next] = 1;
    } else if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void markNextCharAsVisible() {
    switch (widget.progressMode) {
      case ProgressMode.linear:
        return _showNextChar(_nextLinear);
      case ProgressMode.parallel:
        return _showNextChar(_nextParallel);
      case ProgressMode.random:
        return _showNextChar(_nextRandom);
    }
  }

  Color _colorOf(int index) {
    if (widget.colorOf != null) {
      return widget.colorOf!(index);
    }
    return Colors.white;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      markNextCharAsVisible();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < _chars.length; i++)
          Flexible(
            child: AnimatedOpacity(
              opacity: _isVisibleOrNot[i] == 0 ? 0 : 1,
              child: Stack(
                children: [
                  Text(
                    _chars[i],
                    style: TextStyle(
                      height: 1.2,
                      decorationStyle: null,
                      fontSize: 36,
                      fontFamily: 'Road_Rage',
                      decoration: TextDecoration.none,
                      foreground: Paint()
                        ..color = _colorOf(i).withOpacity(0.4)
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 0.1,
                    ),
                  ),
                  Text(
                    _chars[i],
                    style: TextStyle(
                      height: 1.2,
                      decorationStyle: null,
                      fontSize: 36,
                      fontFamily: 'Road_Rage',
                      decoration: TextDecoration.none,
                      foreground: Paint()
                        ..color = _colorOf(i).withOpacity(1)
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.1,
                    ),
                  ),
                ],
              ),
              onEnd: () => markNextCharAsVisible(),
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
          ),
      ],
    );
  }
}

class _AnimatedChar extends StatefulWidget {
  final VoidCallback onComplete;

  const _AnimatedChar({Key? key, required this.onComplete}) : super(key: key);

  @override
  _AnimatedCharState createState() => _AnimatedCharState();
}

class _AnimatedCharState extends State<_AnimatedChar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
