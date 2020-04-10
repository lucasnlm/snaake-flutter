import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/models/food.dart';

import 'sprite_renderer.dart';

class FoodRenderer with SpriteRenderer {
  FoodRenderer(this.tileSize) : _sprite = Sprite('food/food.png');

  final double tileSize;
  final Sprite _sprite;

  Rect _rect;

  void updateFood(Food food) {
    _rect = food != null
        ? Rect.fromLTWH(
            food.x * tileSize,
            food.y * tileSize,
            tileSize,
            tileSize,
          )
        : null;
  }

  @override
  void render(Canvas canvas) {
    if (_rect != null) {
      _sprite.renderRect(canvas, _rect);
    }
  }

  @override
  void update(double dt) {}
}
