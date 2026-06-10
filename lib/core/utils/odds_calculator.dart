import '../../../features/bets/models/bet_status.dart';

double calculatePaid(double wager, int odds, BetStatus status) {
  switch (status) {
    case BetStatus.open:
    case BetStatus.lost:
      return 0.0;
    case BetStatus.voided:
      return wager;
    case BetStatus.won:
      double profit;
      if (odds < 0) {
        profit = wager * 100 / odds.abs();
      } else {
        profit = wager * odds / 100;
      }
      return double.parse((wager + profit).toStringAsFixed(2));
  }
}
