/// The game status.
enum Status {
  /// While the game is being loaded.
  loading,

  /// After the game was loaded.
  running,

  /// When the game is paused.
  pause,

  /// After the snake hit the wall or bite itself.
  gameOver,
}
