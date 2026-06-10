import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/board_game.dart';
import '../../games/models/sport_type.dart';

/// Loads the bundled real DraftKings betting board (assets/data/dk_board.json).
/// Works on every platform — no network, no CORS, no VPN.
final boardProvider = FutureProvider<List<BoardGame>>((ref) async {
  final raw = await rootBundle.loadString('assets/data/dk_board.json');
  final data = json.decode(raw) as Map<String, dynamic>;
  final games = (data['games'] as List? ?? [])
      .map((e) => BoardGame.fromJson(e as Map<String, dynamic>))
      .toList();
  return games;
});

/// Currently selected sport filter on the board page.
final boardSportFilterProvider = StateProvider<SportType?>((ref) => null);

/// Board games grouped by sport, honoring the active filter.
final filteredBoardProvider = Provider<AsyncValue<List<BoardGame>>>((ref) {
  final async = ref.watch(boardProvider);
  final filter = ref.watch(boardSportFilterProvider);
  return async.whenData((games) {
    if (filter == null) return games;
    return games.where((g) => g.sport == filter).toList();
  });
});
