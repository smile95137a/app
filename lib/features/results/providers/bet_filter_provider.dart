import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
import '../../bets/providers/bet_provider.dart';

enum BetTab { all, cashOut, open, live, settled, won, lost }

extension BetTabLabel on BetTab {
  String get label {
    switch (this) {
      case BetTab.all:
        return 'All';
      case BetTab.cashOut:
        return 'Cash Out';
      case BetTab.open:
        return 'Open';
      case BetTab.live:
        return 'Live';
      case BetTab.settled:
        return 'Settled';
      case BetTab.won:
        return 'Won';
      case BetTab.lost:
        return 'Lost';
    }
  }
}

final selectedBetTabProvider = StateProvider<BetTab>((ref) => BetTab.settled);

final filteredBetsProvider = Provider<List<BetSlip>>((ref) {
  final tab = ref.watch(selectedBetTabProvider);
  final bets = ref.watch(betProvider);

  switch (tab) {
    case BetTab.all:
      return bets;
    case BetTab.cashOut:
    case BetTab.live:
    case BetTab.open:
      return bets.where((b) => b.resultStatus == BetStatus.open).toList();
    case BetTab.settled:
      return bets.where((b) => b.resultStatus != BetStatus.open).toList();
    case BetTab.won:
      return bets.where((b) => b.resultStatus == BetStatus.won).toList();
    case BetTab.lost:
      return bets
          .where((b) =>
              b.resultStatus == BetStatus.lost ||
              b.resultStatus == BetStatus.voided)
          .toList();
  }
});
