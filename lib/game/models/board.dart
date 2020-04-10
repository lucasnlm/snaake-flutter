import 'package:equatable/equatable.dart';

class Board extends Equatable {
  Board(this.width, this.height);

  final int width;
  final int height;

  @override
  List<Object> get props => [width, height];

  @override
  bool get stringify => true;
}
