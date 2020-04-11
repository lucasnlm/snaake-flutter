import 'dart:ui';

import 'package:flame/sprite.dart';

import '../models/snake.dart';
import 'sprite_renderer.dart';

/// Used to render the [Snake].
class SnakeRenderer with SpriteRenderer {
  /// Conveninent construtor.
  SnakeRenderer(this.tileSize) : _sprite = Sprite('food/food.png');

  /// The tile size.
  final double tileSize;

  final Sprite _sprite;
  List<Rect> _rect;

  /// Update the Snake position. If null, it won't draw nothing.
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
      for (var rect in _rect) {
        _sprite.renderRect(canvas, rect);
      }
    }
  }

  @override
  void update(double dt) {}
}
