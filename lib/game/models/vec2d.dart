import 'package:equatable/equatable.dart';

class Vec2d extends Equatable {
  Vec2d(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object> get props => [x, y];

  Vec2d copyWith({
    int x,
    int y,
  }) {
    return Vec2d(
      x ?? this.x,
      y ?? this.y,
    );
  }

  @override
  bool get stringify => true;
}
