import 'package:flame/game.dart';
import 'package:unbounded/src/overlays/game_score_overlay.dart';
import 'package:unbounded/src/overlays/menu_buttons_overlay.dart';

const _kOverlayMenuButtons = 'menu.buttons';
const _kOverlayGameScore = 'game.score';

final overlayBuilderMap = <String, OverlayWidgetBuilder>{
  _kOverlayMenuButtons: (context, game) => MenuButtonsOverlay(game),
  _kOverlayGameScore: (context, game) => GameScoreOverlay(game),
};

abstract class Overlays {
  static const menuButtons = _kOverlayMenuButtons;
  static const gameScore = _kOverlayGameScore;
}
