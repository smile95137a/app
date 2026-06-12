class ParlayLeg {
  final String selectionName;
  final String? lineValue;
  final int odds;
  final String betType;
  final String gameId;
  final bool won;

  const ParlayLeg({
    required this.selectionName,
    this.lineValue,
    required this.odds,
    required this.betType,
    required this.gameId,
    required this.won,
  });

  String get oddsDisplay => odds > 0 ? '+$odds' : '$odds';

  String get selectionDisplay => lineValue != null && lineValue!.isNotEmpty
      ? '$selectionName $lineValue'
      : selectionName;

  Map<String, dynamic> toMap() => {
        'selectionName': selectionName,
        'lineValue': lineValue,
        'odds': odds,
        'betType': betType,
        'gameId': gameId,
        'won': won,
      };

  factory ParlayLeg.fromMap(Map<String, dynamic> m) => ParlayLeg(
        selectionName: m['selectionName'] as String,
        lineValue: m['lineValue'] as String?,
        odds: m['odds'] as int,
        betType: m['betType'] as String,
        gameId: m['gameId'] as String,
        won: m['won'] as bool? ?? false,
      );
}
