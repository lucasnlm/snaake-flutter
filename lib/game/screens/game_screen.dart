import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/game_bloc.dart';
import '../blocs/game_events.dart';
import '../blocs/game_state.dart';
import '../models/board.dart';
import '../models/status.dart';
import '../renderer/game_renderer.dart';
import '../widgetss/loading.dart';

/// Main game screen.
class GameScreen extends StatelessWidget {
  /// Conveninent constructor.
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
      body: RawKeyboardListener(
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
            condition: (before, after) => before.status != Status.loading,
            builder: (context, state) {
              return state.status == Status.loading
                  ? Loading()
                  : _gameRenderer.widget;
            },
          ),
        ),
      ),
    );
  }
}
