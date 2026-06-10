import 'package:hive_flutter/hive_flutter.dart';
import '../models/bet_slip.dart';
import '../models/bet_status.dart';
import '../../../storage/hive_boxes.dart';

class BetRepository {
  Box get _box => Hive.box(HiveBoxes.bets);

  List<BetSlip> getAllBets() {
    return _box.values
        .map((e) => BetSlip.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
  }

  List<BetSlip> getOpenBets() =>
      getAllBets().where((b) => b.resultStatus == BetStatus.open).toList();

  List<BetSlip> getSettledBets() =>
      getAllBets().where((b) => b.resultStatus != BetStatus.open).toList();

  BetSlip? getBetById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return BetSlip.fromMap(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> createBet(BetSlip bet) async {
    await _box.put(bet.id, bet.toMap());
  }

  Future<void> updateBet(BetSlip bet) async {
    await _box.put(bet.id, bet.toMap());
  }

  Future<void> deleteBet(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
