import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_balance.dart';
import '../../../storage/hive_boxes.dart';

class BalanceRepository {
  Box get _box => Hive.box(HiveBoxes.balance);
  static const _key = 'current';

  AppBalance getBalance() {
    final raw = _box.get(_key);
    if (raw == null) {
      return AppBalance(balance: 280.84, updatedAt: DateTime.now());
    }
    final balance = AppBalance.fromMap(Map<String, dynamic>.from(raw as Map));
    if (balance.balance == 12583.23 || balance.balance == 209.88) {
      return AppBalance(balance: 280.84, updatedAt: DateTime.now());
    }
    return balance;
  }

  Future<void> updateBalance(AppBalance balance) async {
    await _box.put(_key, balance.toMap());
  }
}
