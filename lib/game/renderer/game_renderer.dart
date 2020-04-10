import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/models/board.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/snake.dart';
import 'package:snaake/game/renderer/snake_renderer.dart';

import 'food_renderer.dart';

class GameRenderer extends Game {
  GameRenderer({
    @required this.screen,
    @required this.board,
    @required this.tileSize,
  }) {
    _foodSprite = FoodRenderer(tileSize);
    _snakeRenderer = SnakeRenderer(tileSize);
  }

  final Rect screen;
  final double tileSize;
  final Board board;

  FoodRenderer _foodSprite;
  SnakeRenderer _snakeRenderer;

  void updateFood(Food food) {
    _foodSprite.updateFood(food);
  }

  void updateSnake(Snake snake) {
    _snakeRenderer.updateSnake(snake);
  }

  @override
  void render(Canvas canvas) {
    canvas.translate(screen.left, screen.top);

    _drawBackground(canvas);

    _foodSprite.render(canvas);
    _snakeRenderer.render(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final fullBackground = Rect.fromLTWH(0, 0, screen.width, screen.height);
    final paint = Paint();
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawRect(fullBackground, paint);
  }

  @override
  void update(double t) {}

  @override
  void resize(Size size) {
    super.resize(Size(screen.width, screen.height));
  }
}
