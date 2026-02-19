import 'package:flame_tiled_test/tiled_game.dart';
import 'package:flutter/material.dart';

class YouWin extends StatelessWidget {
  // Reference to parent game.
  final TiledGame game;
  const YouWin({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You Win!',
                style: TextStyle(color: whiteTextColor, fontSize: 24),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                    game.overlays.remove('YouWin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(fontSize: 28.0, color: blackTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
