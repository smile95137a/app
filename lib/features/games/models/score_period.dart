class ScorePeriod {
  final String teamType; // 'HOME' or 'AWAY'
  final String periodLabel;
  final int score;
  final int sortOrder;

  const ScorePeriod({
    required this.teamType,
    required this.periodLabel,
    required this.score,
    required this.sortOrder,
  });

  ScorePeriod copyWith({int? score}) => ScorePeriod(
        teamType: teamType,
        periodLabel: periodLabel,
        score: score ?? this.score,
        sortOrder: sortOrder,
      );

  Map<String, dynamic> toMap() => {
        'teamType': teamType,
        'periodLabel': periodLabel,
        'score': score,
        'sortOrder': sortOrder,
      };

  factory ScorePeriod.fromMap(Map<String, dynamic> map) => ScorePeriod(
        teamType: map['teamType'] as String,
        periodLabel: map['periodLabel'] as String,
        score: map['score'] as int,
        sortOrder: map['sortOrder'] as int,
      );
}
