import 'package:flutter/widgets.dart';

import '../models/vec2d.dart';

/// Represents a Snake food.
class Food extends Vec2d {
  /// Convenient constructor.
  Food({
    @required int x,
    @required int y,
    @required this.score,
  }) : super(x, y);

  /// If eaten, player will earn [score] value.
  final int score;

  @override
  List<Object> get props => [x, y, score];

  @override
  bool get stringify => true;
}
