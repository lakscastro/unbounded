import 'package:flutter/material.dart';

class SwipeDetector extends StatefulWidget {
  const SwipeDetector({
    Key? key,
    this.onSwipeDown,
    this.onSwipeUp,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.sensitivity = 8,
    this.child,
  }) : super(key: key);

  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final int sensitivity;
  final Widget? child;

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > widget.sensitivity) {
          widget.onSwipeRight?.call();
        } else if (details.delta.dx < -widget.sensitivity) {
          widget.onSwipeLeft?.call();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > widget.sensitivity) {
          widget.onSwipeDown?.call();
        } else if (details.delta.dy < -widget.sensitivity) {
          widget.onSwipeUp?.call();
        }
      },
    );
  }
}
