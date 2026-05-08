import 'package:flame_test/flame_test.dart';
import 'package:flame_tiled_test/tiled_game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TiledGame', () {
    setUp(WidgetsFlutterBinding.ensureInitialized);

    testWithGame('test', TiledGame.new, (game) async {
      await game.ready();
      expect(game.mapComponent, isNotNull);
    });
  });
}
