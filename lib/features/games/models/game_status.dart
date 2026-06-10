enum GameStatus {
  scheduled,
  live,
  finalGame,
  canceled;

  String get displayText {
    switch (this) {
      case GameStatus.scheduled:
        return 'SCHEDULED';
      case GameStatus.live:
        return 'LIVE';
      case GameStatus.finalGame:
        return 'FINAL';
      case GameStatus.canceled:
        return 'CANCELED';
    }
  }

  static GameStatus fromString(String s) {
    switch (s.toUpperCase()) {
      case 'LIVE':
        return GameStatus.live;
      case 'FINAL':
        return GameStatus.finalGame;
      case 'CANCELED':
        return GameStatus.canceled;
      default:
        return GameStatus.scheduled;
    }
  }
}
