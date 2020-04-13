import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snaake/game/blocs/game_bloc.dart';
import 'package:snaake/game/blocs/game_events.dart';
import 'package:snaake/game/models/board.dart';
import 'package:snaake/game/models/food.dart';
import 'package:snaake/game/models/status.dart';
import 'package:snaake/game/models/vec2d.dart';

class _IsPosition extends Matcher {
  const _IsPosition(this.x, this.y);

  final int x;
  final int y;

  @override
  bool matches(dynamic item, Map matchState) =>
      item.snake.head.x == x && item.snake.head.y == y;

  @override
  Description describe(Description description) => description.add('$x, $y');
}

class _IsState extends Matcher {
  const _IsState(
    this.snake, {
    this.food,
    this.score,
    this.status,
  });

  final List<Vec2d> snake;
  final Food food;
  final int score;
  final Status status;

  @override
  bool matches(dynamic item, Map matchState) {
    return listEquals(item.snake.body.toList(), snake) &&
        (food == null || item.food == food) &&
        (score == null || item.score == score) &&
        (status == null || item.status == status);
  }

  @override
  Description describe(Description description) =>
      description.add("${snake.toString()}, $food");
}

void main() {
  group('test snake movement', () {
    blocTest(
      'with no input',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc.add(LoadAssetsEvent());
        bloc.add(OnBoardCreatedEvent(Board(10, 20)));
        List.generate(11, (index) => bloc.add(UpdateGame()));
      },
      expect: List.generate(11, (index) => _IsPosition(5, 10 - index)),
    );

    blocTest(
      'with arrow keys button pressed',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
          Vec2d(5, 13),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ]),
        _IsState([
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
        ]),
        _IsState([
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
        ]),
        _IsState([
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
        ]),
        _IsState([
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
        ]),
        _IsState([
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
        ]),
        _IsState([
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
        ]),
        _IsState(<Vec2d>[
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
        ]),
        _IsState([
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
        ]),
        _IsState([
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
        ]),
        _IsState([
          Vec2d(5, 8),
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 8),
          Vec2d(5, 7),
          Vec2d(4, 7),
        ])
      ],
    );

    blocTest(
      'press opposite direction must not change the direction',
      build: () async => GameBloc(random: Random(200)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
          Vec2d(5, 13),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ]),
        _IsState([
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
        ]),
        _IsState([
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
        ]),
        _IsState([
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
          Vec2d(5, 10),
        ]),
        _IsState([
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
          Vec2d(5, 9),
        ]),
        _IsState([
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
        ]),
        _IsState([
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
          Vec2d(4, 9),
        ]),
        _IsState([
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
          Vec2d(3, 9),
        ]),
        _IsState([
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
        ]),
        _IsState([
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
          Vec2d(3, 8),
        ]),
        _IsState([
          Vec2d(5, 8),
          Vec2d(5, 7),
          Vec2d(4, 7),
          Vec2d(3, 7),
        ]),
        _IsState([
          Vec2d(5, 9),
          Vec2d(5, 8),
          Vec2d(5, 7),
          Vec2d(4, 7),
        ])
      ],
    );

    blocTest(
      'on eat food',
      build: () async => GameBloc(random: Random(0)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(10, 20)))
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        // Eat
        _IsState(
          [Vec2d(5, 10), Vec2d(5, 11), Vec2d(5, 12), Vec2d(5, 13)],
          food: Food(x: 5, y: 9, score: 1),
          score: 0,
        ),

        // New score and food position
        _IsState(
          [Vec2d(5, 9), Vec2d(5, 9), Vec2d(5, 10), Vec2d(5, 11), Vec2d(5, 12)],
          food: Food(x: 4, y: 19, score: 1),
          score: 1,
        ),
      ],
    );
  });

  group('check collision with the wall', () {
    blocTest(
      'on top',
      build: () async => GameBloc(random: Random(100)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(5, 5)))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(2, 1),
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
        ]),
        _IsState([
          Vec2d(2, 0),
          Vec2d(2, 1),
          Vec2d(2, 2),
          Vec2d(2, 3),
        ]),
        _IsState(
          [
            Vec2d(2, 0),
            Vec2d(2, 1),
            Vec2d(2, 2),
            Vec2d(2, 3),
          ],
          status: Status.gameOver,
        ),
      ],
    );

    blocTest(
      'on left',
      build: () async => GameBloc(random: Random(100)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(5, 5)))
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(1, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
        ]),
        _IsState([
          Vec2d(0, 2),
          Vec2d(1, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
        ]),
        _IsState(
          [
            Vec2d(0, 2),
            Vec2d(1, 2),
            Vec2d(2, 2),
            Vec2d(2, 3),
          ],
          status: Status.gameOver,
        ),
      ],
    );

    blocTest(
      'on right',
      build: () async => GameBloc(random: Random(100)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(5, 5)))
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(3, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
        ]),
        _IsState([
          Vec2d(4, 2),
          Vec2d(3, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
        ]),
        _IsState(
          [
            Vec2d(4, 2),
            Vec2d(3, 2),
            Vec2d(2, 2),
            Vec2d(2, 3),
          ],
          status: Status.gameOver,
        ),
      ],
    );

    blocTest(
      'on bottom',
      build: () async => GameBloc(random: Random(100)),
      skip: 3,
      act: (bloc) async {
        bloc
          ..add(LoadAssetsEvent())
          ..add(OnBoardCreatedEvent(Board(5, 5)))
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
          ..add(UpdateGame())
          ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame())
          ..add(UpdateGame());
      },
      expect: [
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
          Vec2d(2, 5),
        ]),
        _IsState([
          Vec2d(3, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
        ]),
        _IsState([
          Vec2d(3, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
          Vec2d(2, 4),
        ]),
        _IsState([
          Vec2d(3, 3),
          Vec2d(3, 2),
          Vec2d(2, 2),
          Vec2d(2, 3),
        ]),
        _IsState([
          Vec2d(3, 4),
          Vec2d(3, 3),
          Vec2d(3, 2),
          Vec2d(2, 2),
        ]),
        _IsState(
          [
            Vec2d(3, 4),
            Vec2d(3, 3),
            Vec2d(3, 2),
            Vec2d(2, 2),
          ],
          status: Status.gameOver,
        ),
      ],
    );
  });

  blocTest(
    'test snake biting itself',
    build: () async => GameBloc(
      random: Random(200),
      snakeInitialLength: 6,
    ),
    skip: 3,
    act: (bloc) async {
      bloc
        ..add(LoadAssetsEvent())
        ..add(OnBoardCreatedEvent(Board(10, 20)))
        ..add(UpdateGame())
        ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight))
        ..add(UpdateGame())
        ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown))
        ..add(UpdateGame())
        ..add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft))
        ..add(UpdateGame())
        ..add(UpdateGame());
    },
    expect: [
      _IsState([
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
        Vec2d(5, 14),
        Vec2d(5, 15),
      ]),
      _IsState([
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
        Vec2d(5, 14),
        Vec2d(5, 15),
      ]),
      _IsState([
        Vec2d(6, 10),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
        Vec2d(5, 14),
      ]),
      _IsState([
        Vec2d(6, 10),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
        Vec2d(5, 14),
      ]),
      _IsState([
        Vec2d(6, 11),
        Vec2d(6, 10),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
      ]),
      _IsState([
        Vec2d(6, 11),
        Vec2d(6, 10),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
      ]),
      _IsState(
        [
          Vec2d(5, 11),
          Vec2d(6, 11),
          Vec2d(6, 10),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ],
      ),
      _IsState(
        [
          Vec2d(5, 11),
          Vec2d(6, 11),
          Vec2d(6, 10),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ],
        status: Status.gameOver,
      ),
    ],
  );

  blocTest(
    'test pause and resume game',
    build: () async => GameBloc(
      random: Random(200),
    ),
    skip: 3,
    act: (bloc) async {
      bloc
        ..add(LoadAssetsEvent())
        ..add(OnBoardCreatedEvent(Board(10, 20)))
        ..add(UpdateGame())
        ..add(UpdateGame())
        ..add(PauseGameEvent())
        ..add(UpdateGame())
        ..add(UpdateGame())
        ..add(ResumeGameEvent())
        ..add(UpdateGame())
        ..add(UpdateGame());
    },
    expect: [
      _IsState(
        [
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
          Vec2d(5, 13),
        ],
        status: Status.running,
      ),
      _IsState(
        [
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ],
        status: Status.running,
      ),
      _IsState(
        [
          Vec2d(5, 9),
          Vec2d(5, 10),
          Vec2d(5, 11),
          Vec2d(5, 12),
        ],
        status: Status.pause,
      ),
      _IsState([
        Vec2d(5, 9),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
      ]),
      _IsState([
        Vec2d(5, 8),
        Vec2d(5, 9),
        Vec2d(5, 10),
        Vec2d(5, 11),
      ]),
      _IsState([
        Vec2d(5, 7),
        Vec2d(5, 8),
        Vec2d(5, 9),
        Vec2d(5, 10),
      ]),
    ],
  );

  blocTest(
    'test new game',
    build: () async => GameBloc(
      random: Random(200),
    ),
    skip: 3,
    act: (bloc) async {
      bloc
        ..add(LoadAssetsEvent())
        ..add(OnBoardCreatedEvent(Board(10, 20)))
        ..add(UpdateGame())
        ..add(UpdateGame())
        ..add(NewGameEvent());
    },
    expect: [
      _IsState([
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
      ]),
      _IsState([
        Vec2d(5, 9),
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
      ]),
      _IsState([
        Vec2d(5, 10),
        Vec2d(5, 11),
        Vec2d(5, 12),
        Vec2d(5, 13),
      ]),
    ],
  );
}
