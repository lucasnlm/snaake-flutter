import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './game/blocs/game_bloc.dart';
import './game/flame/flame_manager.dart';
import './game/screens/game_screen.dart';
import './ui/colors.dart';

void main() => runApp(MainApp());

/// Main application.
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snaake!',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: GameColors.primary,
        primaryColorDark: GameColors.primaryDark,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(
          flameManager: FlameManager(),
          random: Random(),
        ),
        child: GameScreen(),
      ),
    );
  }
}
