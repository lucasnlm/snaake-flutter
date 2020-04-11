import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/models/board.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/snake.dart';
import 'package:snaake/game/models/status.dart';
import 'package:snaake/game/models/vec2d.dart';

class GameState extends Equatable {
  GameState({
    @required this.velocity,
    this.status = Status.Loading,
    this.score = 0,
    this.food,
    this.snake,
    this.board,
  }) : assert(score >= 0);

  final Status status;
  final int score;
  final Food food;
  final Snake snake;
  final Vec2d velocity;
  final Board board;

  @override
  List<Object> get props => [
        status,
        score,
        food,
        snake,
        velocity,
        board,
      ];

  @override
  bool get stringify => true;

  GameState copyWith({
    Status status,
    int score,
    Food food,
    Snake snake,
    Vec2d velocity,
    Board board,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      food: food ?? this.food,
      snake: snake ?? this.snake,
      velocity: velocity ?? this.velocity,
      board: board ?? this.board,
    );
  }
}
