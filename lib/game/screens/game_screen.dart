import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snaake/game/renderer/game_renderer.dart';

class GameScreen extends StatelessWidget {
  final GameRenderer _gameRenderer = GameRenderer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snaake"),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _gameRenderer.widget,
    );
  }
}
