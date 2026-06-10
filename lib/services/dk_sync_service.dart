import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../features/games/models/game.dart';
import '../features/games/models/game_status.dart';
import '../features/games/models/sport_type.dart';

/// Loads real DraftKings games from the bundled snapshot
/// (assets/data/dk_board.json). Works on every platform — no network,
/// no CORS, no VPN. Refresh the snapshot by re-running dk_fetcher/build_board.py.
class DkSyncService {
  Future<List<Game>> fetchGames() async {
    final raw = await rootBundle.loadString('assets/data/dk_board.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = data['games'] as List? ?? [];
    final now = DateTime.now();
    final games = <Game>[];

    for (final item in list) {
      final j = item as Map<String, dynamic>;
      final away = (j['awayTeam'] as String?)?.trim() ?? '';
      final home = (j['homeTeam'] as String?)?.trim() ?? '';
      if (away.isEmpty || home.isEmpty) continue;

      DateTime? start;
      final rawDate = j['startDate'] as String?;
      if (rawDate != null && rawDate.isNotEmpty) {
        start = DateTime.tryParse(rawDate)?.toLocal();
      }

      games.add(Game(
        id: (j['id'] as String?) ?? 'dk-${games.length}',
        sportType: SportType.fromString((j['sport'] as String?) ?? 'other'),
        league: (j['league'] as String?) ?? '',
        awayTeam: away,
        homeTeam: home,
        startTime: start,
        status: _parseStatus(j['status'] as String?),
        scorePeriods: const [],
        createdAt: now,
        updatedAt: now,
      ));
    }

    return games;
  }

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
}
