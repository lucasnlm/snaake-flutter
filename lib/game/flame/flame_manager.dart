import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';

mixin IFlameManager {
  void setup();
}

/// Flame manager used to abstract Flame calls.
class FlameManager with IFlameManager {
  @override
  Future<void> setup() async {
    final flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    await Flame.images.loadAll(<String>[
      'food/food.png',
      'food/red_food.png',
    ]);
  }
}
