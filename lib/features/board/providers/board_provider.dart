import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/board_game.dart';
import '../repositories/board_repository.dart';
import '../../games/models/sport_type.dart';

final boardRepositoryProvider =
    Provider<BoardRepository>((ref) => BoardRepository());

/// Loads the latest synced board first, then falls back to the bundled snapshot.
final boardProvider = FutureProvider<List<BoardGame>>((ref) async {
  final synced = ref.read(boardRepositoryProvider).getAllBoardGames();
  if (synced.isNotEmpty) return synced;

  final raw = await rootBundle.loadString('assets/data/dk_board.json');
  final data = json.decode(raw) as Map<String, dynamic>;
  return (data['games'] as List? ?? [])
      .map((e) => BoardGame.fromJson(e as Map<String, dynamic>))
      .toList();
});

final boardSportFilterProvider = StateProvider<SportType?>((ref) => null);

final filteredBoardProvider = Provider<AsyncValue<List<BoardGame>>>((ref) {
  final async = ref.watch(boardProvider);
  final filter = ref.watch(boardSportFilterProvider);
  return async.whenData((games) {
    if (filter == null) return games;
    return games.where((g) => g.sport == filter).toList();
  });
});
