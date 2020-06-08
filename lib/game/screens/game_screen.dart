import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/game_bloc.dart';
import '../blocs/game_events.dart';
import '../blocs/game_state.dart';
import '../models/board.dart';
import '../models/status.dart';
import '../renderer/game_renderer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/pause_widget.dart';

/// Main game screen.
class GameScreen extends StatelessWidget {
  /// Convenient constructor.
  GameScreen({
    Key key,
  }) : super(key: key);

  final FocusNode _focusNode = FocusNode();

  Rect _getScreenSize(BuildContext context, double appBarHeight) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;

    return Rect.fromLTWH(
      mediaQuery.padding.left,
      appBarHeight + topPadding,
      width - mediaQuery.padding.right,
      height - appBarHeight - topPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GameBloc>(context);

    final appBar = AppBar(
      title: const Text("Snaake"),
      actions: <Widget>[
        BlocBuilder<GameBloc, GameState>(
          condition: (before, after) => before.status != after.status,
          builder: (context, state) {
            switch (state.status) {
              case Status.pause:
                return IconButton(
                  icon: Icon(Icons.play_arrow),
                  tooltip: 'Continue',
                  focusNode: null,
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).add(ResumeGameEvent());
                  },
                );
              case Status.running:
                return IconButton(
                  icon: Icon(Icons.pause),
                  tooltip: 'Pause',
                  focusNode: null,
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).add(PauseGameEvent());
                  },
                );
              default:
                return IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: 'Restart',
                  focusNode: null,
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).add(NewGameEvent());
                  },
                );
            }
          },
        )
      ],
    );

    final screen = _getScreenSize(
      context,
      appBar.preferredSize.height,
    );

    final tileSize = screen.width / 30;

    final board = Board(
      screen.width ~/ tileSize,
      screen.height ~/ tileSize,
    );

    final _gameRenderer = GameRenderer(
      tileSize: tileSize,
      screen: screen,
      board: board,
    );

    bloc.add(OnBoardCreatedEvent(board));

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0.0) {
            bloc.add(OnKeyPressedEvent(LogicalKeyboardKey.arrowRight));
          } else {
            bloc.add(OnKeyPressedEvent(LogicalKeyboardKey.arrowLeft));
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0.0) {
            bloc.add(OnKeyPressedEvent(LogicalKeyboardKey.arrowDown));
          } else {
            bloc.add(OnKeyPressedEvent(LogicalKeyboardKey.arrowUp));
          }
        },
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (event) {
            bloc.add(OnKeyPressedEvent(event.logicalKey));
          },
          child: BlocListener<GameBloc, GameState>(
            listener: (context, state) {
              _gameRenderer.updateFood(state.food);
              _gameRenderer.updateSnake(state.snake);
            },
            child: BlocBuilder<GameBloc, GameState>(
              condition: (before, current) => before.status != current.status,
              builder: (context, state) {
                final bloc = BlocProvider.of<GameBloc>(context);
                return state.status == Status.loading
                    ? LoadingWidget()
                    : Stack(
                        children: <Widget>[
                          _gameRenderer.widget,
                          if (state.status == Status.pause)
                            PauseWidget(
                              text: 'Tap to resume',
                              onTap: () => bloc.add(ResumeGameEvent()),
                            ),
                          if (state.status == Status.gameOver)
                            PauseWidget(
                              text: 'Tap to start a new game',
                              onTap: () => bloc.add(NewGameEvent()),
                            )
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
