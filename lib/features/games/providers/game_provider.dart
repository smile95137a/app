import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game.dart';
import '../repositories/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepository());

final gameProvider = StateNotifierProvider<GameNotifier, List<Game>>((ref) {
  final repo = ref.read(gameRepositoryProvider);
  return GameNotifier(repo);
});

class GameNotifier extends StateNotifier<List<Game>> {
  final GameRepository _repo;

  GameNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() => state = _repo.getAllGames();

  Future<void> add(Game game) async {
    await _repo.createGame(game);
    _load();
  }

  Future<void> update(Game game) async {
    await _repo.updateGame(game);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.deleteGame(id);
    _load();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    _load();
  }

  void refresh() => _load();
}
