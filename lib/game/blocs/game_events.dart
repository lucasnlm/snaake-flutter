import 'package:flutter/services.dart';
import 'package:snaake/game/models/board.dart';

abstract class GameEvent {}

class LoadAssetsEvent extends GameEvent {}

class UpdateGame extends GameEvent {}

class OnBoardCreatedEvent extends GameEvent {
  OnBoardCreatedEvent(this.board);

  final Board board;
}

class OnKeyPressedEvent extends GameEvent {
  OnKeyPressedEvent(this.key);

  final LogicalKeyboardKey key;
}
