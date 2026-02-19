import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_test/actors/ember.dart';

class TiledGame extends FlameGame with HasKeyboardHandlerComponents {
  late TiledComponent mapComponent;
  late EmberPlayer _ember;
  late TiledObject _start;
  late TiledObject _finish;
  TiledObject get finish => _finish;
  late List<TiledObject> _death;
  List<TiledObject> get death => _death;
  late List<TiledObject> _mountains;
  List<TiledObject> get mountains => _mountains;

  TiledGame() : super(camera: CameraComponent.currentCamera);

  double objectSpeed = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Flame.images.load("ember.png");

    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..visibleGameSize = Vector2(480, 480);

    mapComponent = await TiledComponent.load('test_tiled.tmx', Vector2.all(48));
    world.add(mapComponent);

    final objectGroup = mapComponent.tileMap.getLayer<ObjectGroup>('objects');

    _start = objectGroup!.objects.firstWhere((o) => o.name == 'startingPoint');
    _finish = objectGroup.objects.firstWhere((o) => o.name == 'finishPoint');
    _death = objectGroup.objects.where((o) {
      final causesDeathProp = o.properties.byName['causesDeath'];
      final casuesDeathPropVal = causesDeathProp?.value;
      return casuesDeathPropVal == true;
    }).toList();

    _mountains = objectGroup.objects
        .where((o) => o.name == 'mountain')
        .toList();

    final emberStart = Vector2(_start.position.x + 24, _start.position.y + 24);

    _ember = EmberPlayer(position: emberStart);
    await world.add(_ember);
  }

  void reset() {
    _ember.position = Vector2(_start.position.x + 24, _start.position.y + 24);
    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero();
  }
}
