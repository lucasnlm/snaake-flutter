import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

/// Renders a single sprite based on [SpriteComponent] on the game board.
class BoardComponent extends SpriteComponent {
  /// Convenient constructor.
  BoardComponent(String fileName, double tileSize) {
    width = tileSize;
    height = tileSize;
    sprite = Sprite(fileName);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(width * 0.5, height * 0.5);
    super.render(canvas);
    canvas.restore();
  }
}
