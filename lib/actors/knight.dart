import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled_test/actors/monk.dart';
import 'package:flame_tiled_test/tiled_game.dart';

class KnightEnemy extends SpriteAnimationComponent
    with HasGameReference<TiledGame> {
  KnightEnemy({required super.position})
    : super(size: Vector2.all(48), anchor: Anchor.center);

  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  List<MoveDirection> blockedDirections = [];

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('knight.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(32),
        stepTime: 0.33,
      ),
    );
  }
}
