import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class GameSetup {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _setupFullscreen();
    await _setupOrientation();
  }

  static Future<void> dispose() async {}

  static Future<void> _setupOrientation() async =>
      await Flame.device.fullScreen();

  static Future<void> _setupFullscreen() async =>
      await Flame.device.setOrientation(DeviceOrientation.portraitUp);
}
