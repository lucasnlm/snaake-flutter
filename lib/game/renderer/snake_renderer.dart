import 'dart:ui';

import 'package:flame/sprite.dart';

import '../models/snake.dart';
import 'sprite_renderer.dart';

/// Used to render the [Snake].
class SnakeRenderer with SpriteRenderer {
  /// Conveninent construtor.
  SnakeRenderer(this.tileSize)
      : _head = Sprite('snake/head.png'),
        _body = Sprite('snake/body.png'),
        _curve = Sprite('snake/body_curve.png'),
        _tail = Sprite('snake/tail.png');

  /// The tile size.
  final double tileSize;

  final Sprite _head;
  final Sprite _body;
  final Sprite _curve;
  final Sprite _tail;

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
        _body.renderRect(canvas, rect);
      }
    }
  }

  @override
  void update(double dt) {}
}
