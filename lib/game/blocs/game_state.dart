import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/models/board.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/snake.dart';
import 'package:snaake/game/models/vec2d.dart';

class GameState extends Equatable {
  GameState({
    @required this.velocity,
    this.isLoaded = false,
    this.score = 0,
    this.food,
    this.snake,
    this.board,
  }) : assert(score >= 0);

  final bool isLoaded;
  final int score;
  final Food food;
  final Snake snake;
  final Vec2d velocity;
  final Board board;

  @override
  List<Object> get props => [
        isLoaded,
        score,
        food,
        snake,
        velocity,
        board,
      ];

  @override
  bool get stringify => true;

  GameState copyWith({
    bool isLoaded,
    int score,
    Food food,
    Snake snake,
    Vec2d velocity,
    Board board,
  }) {
    return GameState(
      isLoaded: isLoaded ?? this.isLoaded,
      score: score ?? this.score,
      food: food ?? this.food,
      snake: snake ?? this.snake,
      velocity: velocity ?? this.velocity,
      board: board ?? this.board,
    );
  }
}
