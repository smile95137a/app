enum SportType {
  nba,
  mlb,
  soccer,
  nfl,
  other;

  String get displayText {
    switch (this) {
      case SportType.nba:
        return 'NBA';
      case SportType.mlb:
        return 'MLB';
      case SportType.soccer:
        return 'Soccer';
      case SportType.nfl:
        return 'NFL';
      case SportType.other:
        return 'Other';
    }
  }

  List<String> get defaultPeriods {
    switch (this) {
      case SportType.nba:
      case SportType.nfl:
        return ['Q1', 'Q2', 'Q3', 'Q4', 'T'];
      case SportType.mlb:
        return ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'T'];
      case SportType.soccer:
        return ['H1', 'H2', 'T'];
      case SportType.other:
        return ['P1', 'P2', 'T'];
    }
  }

  static SportType fromString(String s) {
    switch (s.toUpperCase()) {
      case 'NBA':
        return SportType.nba;
      case 'MLB':
        return SportType.mlb;
      case 'SOCCER':
        return SportType.soccer;
      case 'NFL':
        return SportType.nfl;
      default:
        return SportType.other;
    }
  }
}
