import 'package:equatable/equatable.dart';

/// Represents a 2D vector using ints.
class Vec2d extends Equatable {
  /// Convenient constructor. Given [x] and [y] positions.
  Vec2d(this.x, this.y);

  /// The vector x position.
  final int x;

  /// The vector y position.
  final int y;

  @override
  List<Object> get props => [x, y];

  /// Creates a copy of the current [Vec2d].
  /// It may also be used to get a copy of it changing one of its fields.
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
