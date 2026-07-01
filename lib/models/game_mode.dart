enum GameMode {
  easy(5, '5×5'),
  medium(6, '6×6'),
  hard(7, '7×7');

  final int gridSize;
  final String displayName;

  const GameMode(this.gridSize, this.displayName);

  int get maxNumber => gridSize * gridSize;
}
