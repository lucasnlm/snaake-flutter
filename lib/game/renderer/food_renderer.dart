import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

import '../models/food.dart';

import 'sprite_renderer.dart';

/// Used to render the [Food].
class FoodRenderer with SpriteRenderer {
  /// Conveninent construtor.
  FoodRenderer(this.tileSize) : _sprite = Sprite('food/food.png');

  /// The tile size.
  final double tileSize;

  final Sprite _sprite;
  Rect _rect;

  /// Update the Food location. If null, it won't draw nothing.
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
