import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/board/models/board_game.dart';
import '../features/games/models/game.dart';
import '../features/games/models/game_status.dart';
import '../features/games/models/sport_type.dart';

class DkSyncService {
  static const _endpoints = <_EspnEndpoint>[
    _EspnEndpoint(SportType.mlb, 'MLB', 'baseball', 'mlb'),
    _EspnEndpoint(SportType.nba, 'NBA', 'basketball', 'nba'),
    _EspnEndpoint(SportType.nfl, 'NFL', 'football', 'nfl'),
    _EspnEndpoint(SportType.soccer, 'Soccer', 'soccer', 'eng.1'),
  ];

  Future<List<Game>> fetchGames() async {
    final board = await fetchBoardGames();
    final now = DateTime.now();
    return board
        .map(
          (g) => Game(
            id: g.id,
            sportType: g.sport,
            league: g.league,
            awayTeam: g.awayTeam,
            homeTeam: g.homeTeam,
            startTime: g.startTime,
            status: g.status,
            scorePeriods: const [],
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList();
  }

  Future<List<BoardGame>> fetchBoardGames({DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    final yyyymmdd = '${targetDate.year.toString().padLeft(4, '0')}'
        '${targetDate.month.toString().padLeft(2, '0')}'
        '${targetDate.day.toString().padLeft(2, '0')}';
    final games = <BoardGame>[];

    for (final endpoint in _endpoints) {
      final uri = Uri.https(
        'site.api.espn.com',
        '/apis/site/v2/sports/${endpoint.sportPath}/${endpoint.leaguePath}/scoreboard',
        {'dates': yyyymmdd},
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) continue;

      final data = json.decode(response.body) as Map<String, dynamic>;
      final events = data['events'] as List? ?? const [];
      for (final raw in events) {
        final event = raw as Map<String, dynamic>;
        final game = _boardGameFromEspnEvent(event, endpoint);
        if (game != null) games.add(game);
      }
    }

    games.sort((a, b) {
      final at = a.startTime;
      final bt = b.startTime;
      if (at == null && bt == null) return 0;
      if (at == null) return 1;
      if (bt == null) return -1;
      return at.compareTo(bt);
    });
    return games;
  }

  BoardGame? _boardGameFromEspnEvent(
    Map<String, dynamic> event,
    _EspnEndpoint endpoint,
  ) {
    final competitions = event['competitions'] as List? ?? const [];
    if (competitions.isEmpty) return null;
    final competition = competitions.first as Map<String, dynamic>;
    final competitors = competition['competitors'] as List? ?? const [];

    Map<String, dynamic>? home;
    Map<String, dynamic>? away;
    for (final raw in competitors) {
      final competitor = raw as Map<String, dynamic>;
      switch (competitor['homeAway']) {
        case 'home':
          home = competitor;
          break;
        case 'away':
          away = competitor;
          break;
      }
    }
    if (home == null || away == null) return null;

    final id = 'espn-${endpoint.sport.name}-${event['id']}';
    final homeTeam = _displayName(home);
    final awayTeam = _displayName(away);
    if (homeTeam.isEmpty || awayTeam.isEmpty) return null;

    final start =
        DateTime.tryParse((event['date'] as String?) ?? '')?.toLocal();
    final status = _parseEspnStatus(competition['status']);
    final odds =
        _oddsFromEspn(competition) ?? _fallbackOdds(id, endpoint.sport);

    return BoardGame(
      id: id,
      sport: endpoint.sport,
      league: endpoint.league,
      awayTeam: awayTeam,
      homeTeam: homeTeam,
      startTime: start,
      status: status,
      homeMoneyline: odds.homeMoneyline,
      awayMoneyline: odds.awayMoneyline,
      spread: odds.spread.abs(),
      homeSpread: odds.homeSpread,
      awaySpread: odds.awaySpread,
      homeSpreadOdds: odds.homeSpreadOdds,
      awaySpreadOdds: odds.awaySpreadOdds,
      total: odds.total,
      overOdds: odds.overOdds,
      underOdds: odds.underOdds,
    );
  }

  String _displayName(Map<String, dynamic> competitor) {
    final team = competitor['team'] as Map<String, dynamic>? ?? const {};
    return ((team['displayName'] ?? team['name']) as String? ?? '').trim();
  }

  _BoardOdds? _oddsFromEspn(Map<String, dynamic> competition) {
    final oddsList = competition['odds'] as List?;
    if (oddsList == null || oddsList.isEmpty) return null;
    final first = oddsList.first as Map<String, dynamic>;
    final homeOdds = first['homeTeamOdds'] as Map<String, dynamic>?;
    final awayOdds = first['awayTeamOdds'] as Map<String, dynamic>?;
    final homeMl = (homeOdds?['moneyLine'] as num?)?.toInt();
    final awayMl = (awayOdds?['moneyLine'] as num?)?.toInt();
    final homeSpread = (homeOdds?['spreadOdds'] as num?)?.toInt();
    final awaySpread = (awayOdds?['spreadOdds'] as num?)?.toInt();
    final spread = (first['spread'] as num?)?.toDouble();
    final overUnder = (first['overUnder'] as num?)?.toDouble();
    if (homeMl == null || awayMl == null) return null;

    final favoriteHome = homeMl < awayMl;
    final magnitude = spread?.abs() ?? 1.5;
    return _BoardOdds(
      homeMoneyline: homeMl,
      awayMoneyline: awayMl,
      homeSpread: favoriteHome ? -magnitude : magnitude,
      awaySpread: favoriteHome ? magnitude : -magnitude,
      homeSpreadOdds: homeSpread ?? -110,
      awaySpreadOdds: awaySpread ?? -110,
      total: overUnder ?? 0,
      overOdds: -110,
      underOdds: -110,
    );
  }

  _BoardOdds _fallbackOdds(String id, SportType sport) {
    final seed = id.codeUnits.fold<int>(0, (sum, c) => (sum + c * 31) & 0xffff);
    final homeFavorite = seed.isEven;
    final homeMl = homeFavorite ? -138 : 127;
    final awayMl = homeFavorite ? 127 : -138;
    final total = switch (sport) {
      SportType.mlb => seed % 2 == 0 ? 8.5 : 9.5,
      SportType.nba => 224.5,
      SportType.nfl => 44.5,
      SportType.soccer => 2.5,
      SportType.other => 0.0,
    };
    final spread = sport == SportType.mlb
        ? 1.5
        : sport == SportType.soccer
            ? 0.5
            : 3.5;
    return _BoardOdds(
      homeMoneyline: homeMl,
      awayMoneyline: awayMl,
      homeSpread: homeFavorite ? -spread : spread,
      awaySpread: homeFavorite ? spread : -spread,
      homeSpreadOdds: -110,
      awaySpreadOdds: -110,
      total: total,
      overOdds: -110,
      underOdds: -110,
    );
  }

  GameStatus _parseEspnStatus(Object? raw) {
    final status = raw as Map<String, dynamic>? ?? const {};
    final type = status['type'] as Map<String, dynamic>? ?? const {};
    final state =
        ((type['state'] ?? type['name']) as String? ?? '').toLowerCase();
    final completed = type['completed'] as bool? ?? false;
    if (completed || state.contains('post')) return GameStatus.finalGame;
    if (state == 'in' || state.contains('progress')) return GameStatus.live;
    return GameStatus.scheduled;
  }
}

class _EspnEndpoint {
  final SportType sport;
  final String league;
  final String sportPath;
  final String leaguePath;

  const _EspnEndpoint(
    this.sport,
    this.league,
    this.sportPath,
    this.leaguePath,
  );
}

class _BoardOdds {
  final int homeMoneyline;
  final int awayMoneyline;
  final double homeSpread;
  final double awaySpread;
  final int homeSpreadOdds;
  final int awaySpreadOdds;
  final double total;
  final int overOdds;
  final int underOdds;

  const _BoardOdds({
    required this.homeMoneyline,
    required this.awayMoneyline,
    required this.homeSpread,
    required this.awaySpread,
    required this.homeSpreadOdds,
    required this.awaySpreadOdds,
    required this.total,
    required this.overOdds,
    required this.underOdds,
  });

  double get spread => homeSpread.abs();
}
