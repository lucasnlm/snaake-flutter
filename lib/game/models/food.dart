import 'package:flutter/widgets.dart';
import 'package:snaake/game/models/vec2d.dart';

class Food extends Vec2d {
  Food({
    @required int x,
    @required int y,
    @required this.score,
  }) : super(x, y);

  final int score;

  @override
  List<Object> get props => [x, y, score];

  @override
  bool get stringify => true;
}
