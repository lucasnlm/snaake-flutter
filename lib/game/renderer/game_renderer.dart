import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import '../../ui/colors.dart';
import '../models/board.dart';
import '../models/food.dart';
import '../models/snake.dart';
import 'board_component.dart';
import 'snake_component.dart';

/// Main game render. Used to render the game screen.
class GameRenderer extends Game {
  /// Convenient constructor.
  /// It requires the [screen] real dimension, the [board] size,
  /// and the [tileSize] used to render the food and snake.
  GameRenderer({
    @required this.screen,
    @required this.board,
    @required this.tileSize,
  }) {
    _food = BoardComponent('food/food.png', tileSize);
    _snake = SnakeComponent(tileSize);
  }

  /// The real screen size.
  final Rect screen;

  /// The board size.
  final Board board;

  /// The tile size used to render the food and snake.
  final double tileSize;

  BoardComponent _food;
  SnakeComponent _snake;

  /// Called to update the [Food] position.
  void updateFood(Food food) {
    if (food != null) {
      _food
        ..x = food.x * tileSize
        ..y = food.y * tileSize;
    }
  }

  /// Called to update the [Snake] positions.
  void updateSnake(Snake snake) {
    _snake.updateSnake(snake);
  }

  @override
  void render(Canvas canvas) {
    canvas.translate(screen.left, screen.top);
    canvas.save();

    _drawBackground(canvas);

    _food.render(canvas);
    _snake.render(canvas);

    canvas.restore();
  }

  void _drawBackground(Canvas canvas) {
    final fullBackground = Rect.fromLTWH(0, 0, screen.width, screen.height);
    final paint = Paint();
    paint.color = GameColors.voidBackground;
    canvas.drawRect(fullBackground, paint);

    final boardBackground =
        Rect.fromLTWH(0, 0, board.width * tileSize, board.height * tileSize);
    paint.color = GameColors.background;
    canvas.drawRect(boardBackground, paint);

    paint.color = GameColors.backgroundChess;
    for (var i = 0; i < board.width; i++) {
      for (var j = 0; j < board.height; j++) {
        if ((j + i) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              tileSize * i,
              tileSize * j,
              tileSize,
              tileSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  void update(double t) {}

  @override
  void resize(Size size) {
    super.resize(Size(screen.width, screen.height));
  }
}
