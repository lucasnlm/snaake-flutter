import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:snaake/game/models/snake.dart';

import 'sprite_renderer.dart';

class SnakeRenderer with SpriteRenderer {
  SnakeRenderer(this.tileSize) : _sprite = Sprite('food/food.png');

  final double tileSize;
  final Sprite _sprite;

  List<Rect> _rect;

  void updateSnake(Snake snake) {
    if (snake != null) {
      _rect = snake.body
          .map(
            (it) => Rect.fromLTWH(
              it.x * tileSize,
              it.y * tileSize,
              tileSize,
              tileSize,
            ),
          )
          .toList();
    } else {
      _rect = null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_rect != null) {
      _rect.forEach((element) {
        _sprite.renderRect(canvas, element);
      });
    }
  }

  @override
  void update(double dt) {}
}
