import 'package:flame/game.dart';
import 'package:flame_tiled_test/overlays/game_over.dart';
import 'package:flame_tiled_test/overlays/you_win.dart';
import 'package:flame_tiled_test/tiled_game.dart';

import 'package:flutter/widgets.dart';

void main() {
  runApp(
    GameWidget<TiledGame>.controlled(
      gameFactory: TiledGame.new,
      overlayBuilderMap: {
        'YouWin': (_, game) => YouWin(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
    ),
  );
}
