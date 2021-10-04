import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unbounded/src/constants/padding.dart';

class ActionButton extends StatefulWidget {
  final String text;

  const ActionButton({Key? key, required this.text}) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  static const purple = Color(0xFF5f0aff);

  late AnimationController _mainButtonAnimation;
  late Animation<double> _heightMainButtonAnimation;

  @override
  void initState() {
    super.initState();

    _mainButtonAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      upperBound: 1,
      lowerBound: 0,
    );

    _heightMainButtonAnimation = CurvedAnimation(
      parent: _mainButtonAnimation,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        _mainButtonAnimation.forward(from: _mainButtonAnimation.value);
      },
      onPointerUp: (details) {
        _mainButtonAnimation.reverse(from: _mainButtonAnimation.value);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(k22dp * 2),
                color: Colors.black,
                boxShadow: const [],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(k22dp * 2),
              child: LayoutBuilder(builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedBuilder(
                    animation: _mainButtonAnimation,
                    builder: (context, child) => Container(
                      width: constraints.maxWidth *
                          _heightMainButtonAnimation.value,
                      decoration: const BoxDecoration(
                        color: purple,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 30,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(vertical: k1dp, horizontal: k22dp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _mainButtonAnimation,
                  builder: (context, child) {
                    return Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.lerp(purple, Colors.black,
                            _heightMainButtonAnimation.value),
                        fontFamily: 'Road_Rage',
                        fontSize: 22,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(k22dp * 2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(k22dp * 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
