/// The game status.
enum Status {
  /// The status while the game is being loaded.
  loading,

  /// The status after the game was loaded.
  running,

  /// The status after the snake hit the wall or bite itself.
  gameOver,
}
