import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:snaake/game/models/vec2d.dart';

class Snake extends Equatable {
  Snake(this.body) : assert(body.length > 3);

  Snake.fromPosition(int x, int y, int length)
      : this(Queue.from(
          List<Vec2d>.generate(length, (i) => Vec2d(x, y + i)),
        ));

  final Queue<Vec2d> body;

  Vec2d get head => body.first;

  bool canEat(Vec2d food) {
    return food != null && head.x == food.x && head.y == food.y;
  }

  Snake move(Vec2d velocity) {
    final newHead = Vec2d(
      head.x + velocity.x,
      head.y + velocity.y,
    );
    return Snake(
      Queue<Vec2d>.from(body)
        ..addFirst(newHead)
        ..removeLast(),
    );
  }

  Snake eat(Vec2d foodPosition) {
    return Snake(
      Queue<Vec2d>.from(body)..addFirst(foodPosition),
    );
  }

  @override
  List<Object> get props => [head.x, head.y, body.length];

  @override
  bool get stringify => true;
}
