import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_test/tiled_game.dart';
import 'package:flutter/services.dart';

enum MoveDirection { left, right, up, down }

class EmberPlayer extends SpriteAnimationComponent
    with KeyboardHandler, HasGameReference<TiledGame> {
  EmberPlayer({required super.position})
    : super(size: Vector2.all(48), anchor: Anchor.center);

  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  List<MoveDirection> blockedDirections = [];

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final leftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final rightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    final upKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    final downKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (leftKeyPressed) {
      horizontalDirection = -1;
    } else if (rightKeyPressed) {
      horizontalDirection = 1;
    } else {
      horizontalDirection = 0;
    }

    if (upKeyPressed) {
      verticalDirection = -1;
    } else if (downKeyPressed) {
      verticalDirection = 1;
    } else {
      verticalDirection = 0;
    }

    return true;
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;

    game.objectSpeed = 0;

    blockedDirections.clear();

    if (position.x - 24 <= 0) {
      blockedDirections.add(MoveDirection.left);
    }
    if (position.x + 24 >= 1200) {
      blockedDirections.add(MoveDirection.right);
    }
    if (position.y - 24 <= 0) {
      blockedDirections.add(MoveDirection.up);
    }
    if (position.y + 24 >= 1200) {
      blockedDirections.add(MoveDirection.down);
    }

    final upTile = Vector2(position.x, position.y - 24);
    final downTile = Vector2(position.x, position.y + 24);
    final leftTile = Vector2(position.x - 24, position.y);
    final rightTile = Vector2(position.x + 24, position.y);

    if (_hasMountain(upTile)) {
      blockedDirections.add(MoveDirection.up);
    }

    if (_hasMountain(downTile)) {
      blockedDirections.add(MoveDirection.down);
    }

    if (_hasMountain(leftTile)) {
      blockedDirections.add(MoveDirection.left);
    }

    if (_hasMountain(rightTile)) {
      blockedDirections.add(MoveDirection.right);
    }

    if (blockedDirections.contains(MoveDirection.left) &&
        horizontalDirection < 0) {
      velocity.x = 0;
    } else if (blockedDirections.contains(MoveDirection.right) &&
        horizontalDirection > 0) {
      velocity.x = 0;
    }

    if (blockedDirections.contains(MoveDirection.up) && verticalDirection < 0) {
      velocity.y = 0;
    } else if (blockedDirections.contains(MoveDirection.down) &&
        verticalDirection > 0) {
      velocity.y = 0;
    }

    position += velocity * dt;

    final deathSpots = game.death;

    for (final spot in deathSpots) {
      if (_isOnTile(
        itemPosition: position,
        tilePosition: spot.position,
        tileSize: spot.size,
      )) {
        game.overlays.add('GameOver');
      }
    }

    if (_isOnTile(
      itemPosition: position,
      tilePosition: game.finish.position,
      tileSize: game.finish.size,
    )) {
      game.overlays.add('YouWin');
    }

    final camera = game.camera;
    if (position.x > 240.0) {
      camera.viewfinder.position = Vector2(
        position.x - 240,
        camera.viewfinder.position.y,
      );
    }

    if (position.y > 240.0) {
      camera.viewfinder.position = Vector2(
        camera.viewfinder.position.x,
        position.y - 240,
      );
    }

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    super.update(dt);
  }

  bool _isOnTile({
    required Vector2 itemPosition,
    required Vector2 tilePosition,
    required Vector2 tileSize,
  }) {
    return itemPosition.x >= tilePosition.x &&
        itemPosition.x <= tilePosition.x + tileSize.x &&
        itemPosition.y >= tilePosition.y &&
        itemPosition.y <= tilePosition.y + tileSize.y;
  }

  bool _hasMountain(Vector2 tile) {
    return game.mountains.any(
      (mountain) => _isOnTile(
        itemPosition: tile,
        tilePosition: mountain.position,
        tileSize: mountain.size,
      ),
    );
  }
}
