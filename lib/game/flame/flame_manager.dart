import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';

abstract class IFlameManager {
  void setup();
}

class FlameManager extends IFlameManager {
  @override
  Future<void> setup() async {
    final flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    Flame.images.loadAll(<String>[
      'food/food.png',
      'food/red_food.png',
    ]);
  }
}
