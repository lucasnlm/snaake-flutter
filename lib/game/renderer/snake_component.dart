import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';

import '../models/snake.dart';
import '../models/vec2d.dart';
import '../renderer/board_component.dart';

/// Renders the snake using [SpriteComponent] for each part of it.
class SnakeComponent extends Component {
  /// Convenient constructor.
  SnakeComponent(this.tileSize);

  /// The tile size. Use to draw the snake.
  final double tileSize;

  List<BoardComponent> _snakeBody;

  BoardComponent _buildHead(Vec2d current, Vec2d prev) {
    final imageRotation = pi / 2;
    final sameAxis = prev.x == current.x;

    final mustInvest = atan2(current.x - prev.x, current.y - prev.y) <= 0.0;

    return BoardComponent('snake/head.png', tileSize)
      ..x = tileSize * current.x
      ..y = tileSize * current.y
      ..angle = (sameAxis ? 0.0 : imageRotation) + (mustInvest ? pi : 0.0);
  }

  BoardComponent _buildTail(Vec2d current, Vec2d prev) {
    final imageRotation = pi / 2;
    final sameAxis = prev.x == current.x;

    final mustInvest = atan2(current.x - prev.x, current.y - prev.y) > 0.0;

    return BoardComponent('snake/tail.png', tileSize)
      ..x = tileSize * current.x
      ..y = tileSize * current.y
      ..angle = (sameAxis ? 0.0 : imageRotation) + (mustInvest ? pi : 0.0);
  }

  BoardComponent _buildBody(Vec2d current, Vec2d prev, Vec2d next) {
    final imageRotation = pi / 2;

    BoardComponent component;

    final diffAngle = atan2(next.x - current.x, next.y - current.y) -
        atan2(prev.x - current.x, prev.y - current.y);

    if (asin(sin(diffAngle)).abs() == (pi / 2)) {
      final isClockwise = asin(sin(diffAngle)) < 0.0;
      final rotate = isClockwise ? 0.0 : imageRotation;

      component = BoardComponent('snake/body_curve.png', tileSize);
      component.angle = -atan2(next.x - current.x, next.y - current.y) + rotate;
    } else {
      component = BoardComponent('snake/body.png', tileSize);
      final sameAxis = prev.x == current.x;
      component.angle = sameAxis ? 0.0 : imageRotation;
    }

    return component
      ..x = tileSize * current.x
      ..y = tileSize * current.y;
  }

  /// Update the snake position using [snake] info.
  void updateSnake(Snake snake) {
    if (snake != null) {
      final snakeBody = LinkedHashSet.from(snake.body).toList();

      if (snakeBody[0].x == snakeBody[1].x &&
          snakeBody[0].y == snakeBody[1].y) {
        print('gfuuuuu');
      }

      _snakeBody = <BoardComponent>[
        _buildHead(
          snakeBody[0],
          snakeBody[1],
        ),
        for (var i = 1; i <= snakeBody.length - 2; i++)
          _buildBody(
            snakeBody[i],
            snakeBody[i - 1],
            snakeBody[i + 1],
          ),
        _buildTail(
          snakeBody.last,
          snakeBody[snakeBody.length - 2],
        )
      ];
    } else {
      _snakeBody = null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_snakeBody != null) {
      for (var part in _snakeBody) {
        part.render(canvas);
      }
    }
  }

  @override
  void update(double dt) {}
}
