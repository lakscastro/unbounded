import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Future<void> setupAll() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _setupFullscreen();
  await _setupOrientation();
}

Future<void> _setupOrientation() async => Flame.device.fullScreen();

Future<void> _setupFullscreen() async =>
    Flame.device.setOrientation(DeviceOrientation.portraitUp);
