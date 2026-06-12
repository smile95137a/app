import '../../games/models/game_status.dart';
import '../../games/models/sport_type.dart';

/// A bettable game on the board: teams + start + generated odds.
/// Parsed from the bundled assets/data/dk_board.json (real DraftKings games).
class BoardGame {
  final String id;
  final SportType sport;
  final String league;
  final String awayTeam;
  final String homeTeam;
  final DateTime? startTime;
  final GameStatus status;

  final int homeMoneyline;
  final int awayMoneyline;
  final double spread; // positive magnitude
  final double homeSpread;
  final double awaySpread;
  final int homeSpreadOdds;
  final int awaySpreadOdds;
  final double total;
  final int overOdds;
  final int underOdds;

  const BoardGame({
    required this.id,
    required this.sport,
    required this.league,
    required this.awayTeam,
    required this.homeTeam,
    required this.startTime,
    required this.status,
    required this.homeMoneyline,
    required this.awayMoneyline,
    required this.spread,
    required this.homeSpread,
    required this.awaySpread,
    required this.homeSpreadOdds,
    required this.awaySpreadOdds,
    required this.total,
    required this.overOdds,
    required this.underOdds,
  });

  factory BoardGame.fromJson(Map<String, dynamic> j) {
    DateTime? start;
    final raw = j['startDate'] as String?;
    if (raw != null && raw.isNotEmpty) {
      start = DateTime.tryParse(raw)?.toLocal();
    }
    return BoardGame(
      id: j['id'] as String,
      sport: SportType.fromString((j['sport'] as String?) ?? 'other'),
      league: (j['league'] as String?) ?? '',
      awayTeam: (j['awayTeam'] as String?) ?? '',
      homeTeam: (j['homeTeam'] as String?) ?? '',
      startTime: start,
      status: _parseStatus(j['status'] as String?),
      homeMoneyline: (j['homeML'] as num?)?.toInt() ?? 0,
      awayMoneyline: (j['awayML'] as num?)?.toInt() ?? 0,
      spread: (j['spread'] as num?)?.toDouble() ?? 0,
      homeSpread: (j['homeSpread'] as num?)?.toDouble() ?? 0,
      awaySpread: (j['awaySpread'] as num?)?.toDouble() ?? 0,
      homeSpreadOdds: (j['homeSpreadOdds'] as num?)?.toInt() ?? -110,
      awaySpreadOdds: (j['awaySpreadOdds'] as num?)?.toInt() ?? -110,
      total: (j['total'] as num?)?.toDouble() ?? 0,
      overOdds: (j['overOdds'] as num?)?.toInt() ?? -110,
      underOdds: (j['underOdds'] as num?)?.toInt() ?? -110,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sport': sport.displayText,
        'league': league,
        'awayTeam': awayTeam,
        'homeTeam': homeTeam,
        'startDate': startTime?.toUtc().toIso8601String(),
        'status': status.name,
        'homeML': homeMoneyline,
        'awayML': awayMoneyline,
        'spread': spread,
        'homeSpread': homeSpread,
        'awaySpread': awaySpread,
        'homeSpreadOdds': homeSpreadOdds,
        'awaySpreadOdds': awaySpreadOdds,
        'total': total,
        'overOdds': overOdds,
        'underOdds': underOdds,
      };

  static GameStatus _parseStatus(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'live':
        return GameStatus.live;
      case 'finalgame':
      case 'final':
        return GameStatus.finalGame;
      case 'canceled':
      case 'cancelled':
        return GameStatus.canceled;
      default:
        return GameStatus.scheduled;
    }
  }

  static String fmtOdds(int o) => o > 0 ? '+$o' : '$o';
  static String fmtSpread(double s) {
    final t = s == s.roundToDouble() ? s.toStringAsFixed(1) : s.toString();
    return s > 0 ? '+$t' : t;
  }
}
