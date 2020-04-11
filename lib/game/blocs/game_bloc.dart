import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/blocs/game_events.dart';
import 'package:snaake/game/blocs/game_state.dart';
import 'package:snaake/game/flame/flame_manager.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/snake.dart';
import 'package:snaake/game/models/vec2d.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    @required this.random,
    this.flameManager,
  }) : assert(random != null) {
    add(LoadAssetsEvent());
  }

  final IFlameManager flameManager;
  final Random random;

  @override
  GameState get initialState {
    return GameState(
      isLoaded: false,
      score: 0,
      velocity: Vec2d(0, -1),
    );
  }

  Future<void> preloadAssets() async {
    flameManager?.setup();
  }

  void _startGame() {
    Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        if (state.isLoaded) {
          add(UpdateGame());
        }
      },
    );
  }

  Snake _newSnake() {
    final x = state.board.width ~/ 2;
    final y = state.board.height ~/ 2;
    return Snake.fromPosition(x, y, 4);
  }

  Food _getRandomFood() {
    return Food(
      x: random.nextInt(state.board.width),
      y: random.nextInt(state.board.height),
      score: 1,
    );
  }

  GameState _updateGame() {
    Snake newSnake =
        (state.snake == null) ? _newSnake() : state.snake.move(state.velocity);
    int score = 0;

    Food food = state.food;

    if (newSnake.canEat(food)) {
      score += food.score;
      newSnake = newSnake.eat(food);
      food = null;
    }

    final newFood = (food == null) ? _getRandomFood() : food;

    return state.copyWith(
      snake: newSnake,
      score: score,
      food: newFood,
    );
  }

  Vec2d _handleDirection(OnKeyPressedEvent event) {
    final pressedKey = event.key.keyId;
    Vec2d newDirection;

    if (pressedKey == LogicalKeyboardKey.arrowRight.keyId) {
      newDirection = Vec2d(1, 0);
    } else if (pressedKey == LogicalKeyboardKey.arrowLeft.keyId) {
      newDirection = Vec2d(-1, 0);
    } else if (pressedKey == LogicalKeyboardKey.arrowUp.keyId) {
      newDirection = Vec2d(0, -1);
    } else if (pressedKey == LogicalKeyboardKey.arrowDown.keyId) {
      newDirection = Vec2d(0, 1);
    }

    return newDirection;
  }

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    switch (event.runtimeType) {
      case UpdateGame:
        if (state.board != null) {
          yield _updateGame();
        }
        break;
      case OnKeyPressedEvent:
        final newDirection = _handleDirection(event);
        if (newDirection != null) {
          yield state.copyWith(velocity: newDirection);
        }
        break;
      case LoadAssetsEvent:
        await preloadAssets();
        yield state.copyWith(isLoaded: true);
        _startGame();
        break;
      case OnBoardCreatedEvent:
        yield state.copyWith(
          board: (event as OnBoardCreatedEvent).board,
        );
        break;
    }
  }
}
