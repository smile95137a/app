import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';
import '../../../storage/hive_boxes.dart';

class GameRepository {
  Box get _box => Hive.box(HiveBoxes.games);

  List<Game> getAllGames() {
    return _box.values
        .map((e) => Game.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Game? getGameById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return Game.fromMap(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> createGame(Game game) async {
    await _box.put(game.id, game.toMap());
  }

  Future<void> updateGame(Game game) async {
    await _box.put(game.id, game.toMap());
  }

  Future<void> deleteGame(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
