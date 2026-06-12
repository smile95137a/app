import 'package:hive_flutter/hive_flutter.dart';
import '../../../storage/hive_boxes.dart';
import '../models/board_game.dart';

class BoardRepository {
  Box get _box => Hive.box(HiveBoxes.boardGames);

  List<BoardGame> getAllBoardGames() {
    return _box.values
        .map((e) => BoardGame.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) {
        final at = a.startTime;
        final bt = b.startTime;
        if (at == null && bt == null) return 0;
        if (at == null) return 1;
        if (bt == null) return -1;
        return at.compareTo(bt);
      });
  }

  Future<void> replaceAll(List<BoardGame> games) async {
    await _box.clear();
    await _box.putAll({
      for (final game in games) game.id: game.toJson(),
    });
  }

  Future<void> clearAll() => _box.clear();
}
