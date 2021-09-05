import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  final Widget? child;

  final void Function(DragUpdateDetails)? onSwipeLeft;
  final void Function(DragUpdateDetails)? onSwipeRight;
  final void Function(DragUpdateDetails)? onSwipeDown;
  final void Function(DragUpdateDetails)? onSwipeUp;
  final double sensitivity;

  const SwipeDetector({
    Key? key,
    this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeDown,
    this.onSwipeUp,
    this.sensitivity = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > sensitivity) {
          onSwipeRight?.call(details);
        } else if (details.delta.dx < -sensitivity) {
          onSwipeLeft?.call(details);
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > sensitivity) {
          onSwipeDown?.call(details);
        } else if (details.delta.dy < -sensitivity) {
          onSwipeUp?.call(details);
        }
      },
      child: child,
    );
  }
}
