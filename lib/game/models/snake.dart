import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../models/vec2d.dart';

/// Represents the Snake.
class Snake extends Equatable {
  /// Creates a Snake given its body positions.
  Snake(this.body) : assert(body.length > 3);

  /// Creates a Snake given the head position and its length.
  Snake.fromPosition(int x, int y, int length)
      : this(Queue.from(
          List<Vec2d>.generate(length, (i) => Vec2d(x, y + i)),
        ));

  /// Store the snake position.
  final Queue<Vec2d> body;

  /// Get the Snake head position.
  Vec2d get head => body.first;

  /// Check if Snake can eat a food, given is position [food].
  bool canEat(Vec2d food) {
    return food != null && head.x == food.x && head.y == food.y;
  }

  /// Move the Snake to a new position given a [velocity].
  /// Returns a new Snake after the movement.
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

  /// Eats a food at position [foodPosition] returning the new Snake body.
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
