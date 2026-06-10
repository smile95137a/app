import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_balance.dart';
import '../repositories/balance_repository.dart';

final balanceRepositoryProvider =
    Provider<BalanceRepository>((ref) => BalanceRepository());

final balanceProvider = StateNotifierProvider<BalanceNotifier, AppBalance>((ref) {
  final repo = ref.read(balanceRepositoryProvider);
  return BalanceNotifier(repo);
});

class BalanceNotifier extends StateNotifier<AppBalance> {
  final BalanceRepository _repo;

  BalanceNotifier(this._repo) : super(_repo.getBalance());

  Future<void> update(double amount) async {
    final newBalance = AppBalance(balance: amount, updatedAt: DateTime.now());
    await _repo.updateBalance(newBalance);
    state = newBalance;
  }
}
