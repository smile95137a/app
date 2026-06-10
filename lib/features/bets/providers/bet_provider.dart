import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bet_slip.dart';
import '../repositories/bet_repository.dart';

final betRepositoryProvider = Provider<BetRepository>((ref) => BetRepository());

final betProvider = StateNotifierProvider<BetNotifier, List<BetSlip>>((ref) {
  final repo = ref.read(betRepositoryProvider);
  return BetNotifier(repo);
});

class BetNotifier extends StateNotifier<List<BetSlip>> {
  final BetRepository _repo;

  BetNotifier(this._repo) : super([]) {
    _load();
  }

  void _load() => state = _repo.getAllBets();

  Future<void> add(BetSlip bet) async {
    await _repo.createBet(bet);
    _load();
  }

  Future<void> update(BetSlip bet) async {
    await _repo.updateBet(bet);
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.deleteBet(id);
    _load();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    _load();
  }

  void refresh() => _load();
}
