import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class AlreadyDisposed implements Exception {
  final String message =
      'Game already ended, try call restart() to a new game!';
}

class AlreadyInitialized implements Exception {
  final String message =
      'Game is already running, to start again you first need call restart()';
}

class EngineIsNotRunning implements Exception {
  final String message = 'To update engine you first need call start()';
}

class EngineIsNotReady implements Exception {
  final String message =
      'To make sure that you can call start(), first call dispose()';
}

enum StateLifecycle {
  initial,
  running,
  disposed,
}

abstract class Engine {
  const Engine();

  /// Create a new [engineState] instance, use it for to
  /// start or restart a game
  EngineState createState(covariant Engine config);
}

abstract class EngineState<T extends Engine> {
  final T config;

  const EngineState(this.config);

  void init() {}
  void update() {}
  void dispose() {}
}
