import 'dart:convert';
import 'game_status.dart';
import 'sport_type.dart';
import 'score_period.dart';

class Game {
  final String id;
  final SportType sportType;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final DateTime? startTime;
  final GameStatus status;
  final List<ScorePeriod> scorePeriods;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Game({
    required this.id,
    required this.sportType,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    this.startTime,
    required this.status,
    required this.scorePeriods,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName => '$awayTeam vs $homeTeam';

  Game copyWith({
    String? league,
    String? homeTeam,
    String? awayTeam,
    DateTime? startTime,
    GameStatus? status,
    List<ScorePeriod>? scorePeriods,
  }) =>
      Game(
        id: id,
        sportType: sportType,
        league: league ?? this.league,
        homeTeam: homeTeam ?? this.homeTeam,
        awayTeam: awayTeam ?? this.awayTeam,
        startTime: startTime ?? this.startTime,
        status: status ?? this.status,
        scorePeriods: scorePeriods ?? this.scorePeriods,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'sportType': sportType.name,
        'league': league,
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'startTime': startTime?.millisecondsSinceEpoch,
        'status': status.name,
        'scorePeriods': jsonEncode(scorePeriods.map((e) => e.toMap()).toList()),
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory Game.fromMap(Map<String, dynamic> map) {
    final periodsJson = map['scorePeriods'] as String? ?? '[]';
    final periodsRaw = jsonDecode(periodsJson) as List<dynamic>;
    return Game(
      id: map['id'] as String,
      sportType: SportType.fromString(map['sportType'] as String),
      league: map['league'] as String,
      homeTeam: map['homeTeam'] as String,
      awayTeam: map['awayTeam'] as String,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      status: GameStatus.fromString(map['status'] as String),
      scorePeriods:
          periodsRaw.map((e) => ScorePeriod.fromMap(e as Map<String, dynamic>)).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }
}
