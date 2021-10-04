import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class UnboundedGame extends FlameGame {
  Size get _size => size.toSize();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
