import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../flame/flame_manager.dart';
import '../models/food.dart';
import '../models/snake.dart';
import '../models/status.dart';
import '../models/vec2d.dart';
import 'game_events.dart';
import 'game_state.dart';

/// Game logic controller.
class GameBloc extends Bloc<GameEvent, GameState> {
  /// Convenient constructor.
  GameBloc({
    @required this.random,
    this.flameManager,
    this.snakeInitialLength = 4,
    this.updatePeriod = 150,
  })  : assert(random != null),
        assert(snakeInitialLength >= 4) {
    add(LoadAssetsEvent());
  }

  /// Flame wrapper.
  final IFlameManager flameManager;

  /// Random generator. Used to create a random food position.
  final Random random;

  /// The snake initial length. Default value is 4.
  final int snakeInitialLength;

  /// The game update period in miliseconds.
  final int updatePeriod;

  @override
  GameState get initialState {
    return GameState(
      status: Status.loading,
      score: 0,
      velocity: Vec2d(0, -1),
    );
  }

  Future<void> _preloadAssets() async {
    await flameManager?.setup();
  }

  void _startGame() {
    Timer.periodic(
      Duration(
        milliseconds: updatePeriod,
      ),
      (timer) {
        if (state.status == Status.running) {
          add(UpdateGame());
        }
      },
    );
  }

  Snake _newSnake() {
    final x = state.board.width ~/ 2;
    final y = state.board.height ~/ 2;
    return Snake.fromPosition(x, y, snakeInitialLength);
  }

  Food _getRandomFood() {
    return Food(
      x: random.nextInt(state.board.width),
      y: random.nextInt(state.board.height),
      score: 1,
    );
  }

  GameState _updateGame() {
    final oldSnake = state.snake;
    var newSnake = oldSnake?.move(state.velocity) ?? _newSnake();
    var score = 0;
    var food = state.food;
    var status = state.status;

    // Check if the snake hit the wall
    if ((newSnake.head.x >= state.board.width || newSnake.head.x < 0) ||
        (newSnake.head.y >= state.board.height || newSnake.head.y < 0)) {
      newSnake = oldSnake;
      status = Status.gameOver;
    } else if (oldSnake?.hasBitenItself() ?? false) {
      newSnake = oldSnake;
      status = Status.gameOver;
    } else {
      if (newSnake.canEat(food)) {
        score += food.score;
        newSnake = newSnake.eat(food.x, food.y);
        food = null;
      }

      food ??= _getRandomFood();
    }

    return state.copyWith(
      snake: newSnake,
      score: score,
      food: food,
      status: status,
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

    // Block opposite directions
    if (newDirection != null && (state.velocity.x + newDirection.x == 0) ||
        (state.velocity.y + newDirection.y == 0)) {
      newDirection = null;
    }

    return newDirection;
  }

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    switch (event.runtimeType) {
      case UpdateGame:
        if (state.board != null && state.status == Status.running) {
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
        await _preloadAssets();
        yield state.copyWith(status: Status.running);
        _startGame();
        break;
      case OnBoardCreatedEvent:
        yield state.copyWith(
          board: (event as OnBoardCreatedEvent).board,
        );
        break;
      case PauseGameEvent:
        yield state.copyWith(
          status: Status.pause,
        );
        break;
      case ResumeGameEvent:
        if (state.status == Status.pause) {
          yield state.copyWith(
            status: Status.running,
          );
        }
        break;
      case NewGameEvent:
        yield state.copyWith(
          status: Status.running,
          score: 0,
          velocity: Vec2d(0, -1),
          food: _getRandomFood(),
          snake: _newSnake(),
        );
        break;
    }
  }
}
