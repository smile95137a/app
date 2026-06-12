import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/board/models/board_game.dart';
import '../features/games/models/game.dart';
import '../features/games/models/game_status.dart';
import '../features/games/models/sport_type.dart';

class DkSyncService {
  static final Uri _worldCupMarketsUri = Uri.parse(
    'https://sportsbook-nash.draftkings.com/sites/US-SB/api/sportscontent/'
    'controldata/league/leagueSubcategory/v1/markets'
    '?isBatchable=false'
    '&templateVars=209533'
    '&eventsQuery=%24filter%3DleagueId%20eq%20%27209533%27%20AND%20'
    'clientMetadata%2FSubcategories%2Fany%28s%3A%20s%2FId%20eq%20%274514%27%29'
    '&marketsQuery=%24filter%3DclientMetadata%2FsubCategoryId%20eq%20%274514%27%20'
    'AND%20tags%2Fall%28t%3A%20t%20ne%20%27SportcastBetBuilder%27%29'
    '&include=Events'
    '&entity=events',
  );

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
    return _fetchDraftKingsSportsbookBoard();
  }

  Future<List<BoardGame>> _fetchDraftKingsSportsbookBoard() async {
    try {
      final response = await http.get(
        _worldCupMarketsUri,
        headers: const {
          'Accept': 'application/json, text/plain, */*',
          'Origin': 'https://sportsbook.draftkings.com',
          'Referer':
              'https://sportsbook.draftkings.com/leagues/soccer/world-cup-2026',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/125.0 Safari/537.36',
        },
      );
      if (response.statusCode != 200) return const [];

      final data = json.decode(response.body) as Map<String, dynamic>;
      final games = _boardGamesFromSportsbookMarkets(data);
      games.sort((a, b) {
        final at = a.startTime;
        final bt = b.startTime;
        if (at == null && bt == null) return 0;
        if (at == null) return 1;
        if (bt == null) return -1;
        return at.compareTo(bt);
      });
      return games;
    } catch (_) {
      return const [];
    }
  }

  List<BoardGame> _boardGamesFromSportsbookMarkets(Map<String, dynamic> data) {
    final markets = (data['markets'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final selections = (data['selections'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final selectionsByMarket = <String, List<Map<String, dynamic>>>{};
    for (final selection in selections) {
      final marketId = selection['marketId'] as String?;
      if (marketId == null) continue;
      selectionsByMarket.putIfAbsent(marketId, () => []).add(selection);
    }

    final moneylineMarketByEvent = <String, Map<String, dynamic>>{};
    for (final market in markets) {
      final name = (market['name'] as String? ?? '').toLowerCase();
      final eventId = market['eventId'] as String?;
      if (eventId == null || name != 'moneyline') continue;
      moneylineMarketByEvent[eventId] = market;
    }

    final games = <BoardGame>[];
    for (final rawEvent in data['events'] as List? ?? const []) {
      final event = rawEvent as Map<String, dynamic>;
      final eventId = event['id'] as String?;
      if (eventId == null) continue;

      final participants = (event['participants'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
      final home = _sportsbookParticipant(participants, 'Home');
      final away = _sportsbookParticipant(participants, 'Away');
      if (home == null || away == null) continue;

      final market = moneylineMarketByEvent[eventId];
      if (market == null) continue;

      final marketSelections = selectionsByMarket[market['id']] ?? const [];
      final homeMl = _sportsbookOdds(marketSelections, 'Home');
      final awayMl = _sportsbookOdds(marketSelections, 'Away');
      if (homeMl == null || awayMl == null) continue;

      final id = 'dk-sb-$eventId';
      final fallback = _fallbackOdds(id, SportType.soccer);
      games.add(
        BoardGame(
          id: id,
          sport: SportType.soccer,
          league: 'World Cup 2026',
          awayTeam: (away['name'] as String? ?? '').trim(),
          homeTeam: (home['name'] as String? ?? '').trim(),
          startTime: DateTime.tryParse(
            (event['startEventDate'] as String? ?? '').replaceFirst(
              '.0000000Z',
              'Z',
            ),
          )?.toLocal(),
          status: _parseSportsbookStatus(event['status']),
          homeMoneyline: homeMl,
          awayMoneyline: awayMl,
          spread: fallback.spread,
          homeSpread: fallback.homeSpread,
          awaySpread: fallback.awaySpread,
          homeSpreadOdds: fallback.homeSpreadOdds,
          awaySpreadOdds: fallback.awaySpreadOdds,
          total: fallback.total,
          overOdds: fallback.overOdds,
          underOdds: fallback.underOdds,
        ),
      );
    }
    return games;
  }

  Map<String, dynamic>? _sportsbookParticipant(
    List<Map<String, dynamic>> participants,
    String venueRole,
  ) {
    for (final participant in participants) {
      if (participant['venueRole'] == venueRole) return participant;
    }
    return null;
  }

  int? _sportsbookOdds(
    List<Map<String, dynamic>> selections,
    String outcomeType,
  ) {
    for (final selection in selections) {
      if (selection['outcomeType'] != outcomeType) continue;
      final displayOdds = selection['displayOdds'] as Map<String, dynamic>?;
      return _parseAmericanOdds(displayOdds?['american'] as String?);
    }
    return null;
  }

  int? _parseAmericanOdds(String? value) {
    if (value == null) return null;
    return int.tryParse(value.replaceAll('+', '').trim());
  }

  GameStatus _parseSportsbookStatus(Object? raw) {
    switch ((raw as String? ?? '').toUpperCase()) {
      case 'IN_PROGRESS':
      case 'STARTED':
        return GameStatus.live;
      case 'FINAL':
      case 'COMPLETED':
        return GameStatus.finalGame;
      case 'CANCELED':
      case 'CANCELLED':
      case 'POSTPONED':
      case 'SUSPENDED':
        return GameStatus.canceled;
      default:
        return GameStatus.scheduled;
    }
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
