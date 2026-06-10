import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/odds_calculator.dart';
import '../../results/widgets/results_header.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
import '../../bets/providers/bet_provider.dart';
import '../../games/models/game.dart';
import '../../games/models/game_status.dart';
import '../../games/models/sport_type.dart';
import '../../games/providers/game_provider.dart';
import '../models/board_game.dart';
import '../providers/board_provider.dart';

class BettingBoardPage extends ConsumerWidget {
  final VoidCallback? onLogoTap;
  const BettingBoardPage({super.key, this.onLogoTap});

  static const _filters = <(String, SportType?)>[
    ('All', null),
    ('MLB', SportType.mlb),
    ('NBA', SportType.nba),
    ('NFL', SportType.nfl),
    ('Soccer', SportType.soccer),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(filteredBoardProvider);
    final activeFilter = ref.watch(boardSportFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: ResultsHeader(onSecretTap: onLogoTap),
        ),
        // Sport filter chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final (label, sport) = _filters[i];
              final selected = sport == activeFilter;
              return GestureDetector(
                onTap: () =>
                    ref.read(boardSportFilterProvider.notifier).state = sport,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.green : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected ? AppColors.green : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.black : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: boardAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
            error: (e, _) => Center(
              child: Text('載入失敗：$e',
                  style: const TextStyle(color: AppColors.textMuted)),
            ),
            data: (games) {
              if (games.isEmpty) {
                return const Center(
                  child: Text('沒有賽事',
                      style: TextStyle(color: AppColors.textMuted)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 90),
                itemCount: games.length,
                itemBuilder: (_, i) => _GameCard(
                  game: games[i],
                  onPlace: (sel, type, line, odds) =>
                      _placeBet(context, ref, games[i], sel, type, line, odds),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _placeBet(
    BuildContext context,
    WidgetRef ref,
    BoardGame g,
    String selection,
    String betType,
    String? line,
    int odds,
  ) async {
    const wager = 10.0;
    final now = DateTime.now();

    // Upsert the underlying game so My Bets shows the real matchup.
    await ref.read(gameProvider.notifier).add(Game(
          id: g.id,
          sportType: g.sport,
          league: g.league,
          homeTeam: g.homeTeam,
          awayTeam: g.awayTeam,
          startTime: g.startTime,
          status: g.status,
          scorePeriods: const [],
          createdAt: now,
          updatedAt: now,
        ));

    final bet = BetSlip(
      id: const Uuid().v4(),
      betCode: 'MK${now.millisecondsSinceEpoch}',
      gameId: g.id,
      sportType: g.sport,
      selectionName: selection,
      betType: betType,
      lineValue: line,
      odds: odds,
      wagerAmount: wager,
      paidAmount: calculatePaid(wager, odds, BetStatus.open),
      resultStatus: BetStatus.open,
      placedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(betProvider.notifier).add(bet);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.greenDarkBadge,
          content: Text(
            '已下注 \$10：$selection${line != null ? ' $line' : ''} (${BoardGame.fmtOdds(odds)})',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }
}

typedef _PlaceBet = void Function(
    String selection, String betType, String? line, int odds);

class _GameCard extends StatelessWidget {
  final BoardGame game;
  final _PlaceBet onPlace;
  const _GameCard({required this.game, required this.onPlace});

  @override
  Widget build(BuildContext context) {
    final live = game.status == GameStatus.live;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // ── meta row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 9, 12, 6),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.innerCard,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(game.league,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                if (live)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC0000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('LIVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900)),
                  )
                else
                  Text(_startLabel(game.startTime),
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          // ── column headers ──
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 2),
            child: Row(
              children: [
                Spacer(flex: 5),
                Expanded(flex: 3, child: _ColHead('SPREAD')),
                Expanded(flex: 3, child: _ColHead('TOTAL')),
                Expanded(flex: 3, child: _ColHead('MONEY')),
              ],
            ),
          ),
          // ── away row ──
          _TeamRow(
            team: game.awayTeam,
            spreadLabel: BoardGame.fmtSpread(game.awaySpread),
            spreadOdds: game.awaySpreadOdds,
            totalLabel: 'O ${game.total}',
            totalOdds: game.overOdds,
            moneyOdds: game.awayMoneyline,
            onSpread: () => onPlace(game.awayTeam, 'Spread',
                BoardGame.fmtSpread(game.awaySpread), game.awaySpreadOdds),
            onTotal: () => onPlace(game.awayTeam, 'Total',
                'O ${game.total}', game.overOdds),
            onMoney: () =>
                onPlace(game.awayTeam, 'Moneyline', null, game.awayMoneyline),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // ── home row ──
          _TeamRow(
            team: game.homeTeam,
            spreadLabel: BoardGame.fmtSpread(game.homeSpread),
            spreadOdds: game.homeSpreadOdds,
            totalLabel: 'U ${game.total}',
            totalOdds: game.underOdds,
            moneyOdds: game.homeMoneyline,
            onSpread: () => onPlace(game.homeTeam, 'Spread',
                BoardGame.fmtSpread(game.homeSpread), game.homeSpreadOdds),
            onTotal: () => onPlace(game.homeTeam, 'Total',
                'U ${game.total}', game.underOdds),
            onMoney: () =>
                onPlace(game.homeTeam, 'Moneyline', null, game.homeMoneyline),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  static String _startLabel(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final h = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final sameDay =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (sameDay) return 'Today $h:$m $ampm';
    const wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${wd[dt.weekday - 1]} $h:$m $ampm';
  }
}

class _ColHead extends StatelessWidget {
  final String text;
  const _ColHead(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5),
      );
}

class _TeamRow extends StatelessWidget {
  final String team;
  final String spreadLabel;
  final int spreadOdds;
  final String totalLabel;
  final int totalOdds;
  final int moneyOdds;
  final VoidCallback onSpread, onTotal, onMoney;

  const _TeamRow({
    required this.team,
    required this.spreadLabel,
    required this.spreadOdds,
    required this.totalLabel,
    required this.totalOdds,
    required this.moneyOdds,
    required this.onSpread,
    required this.onTotal,
    required this.onMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              team,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              flex: 3,
              child: _OddsCell(top: spreadLabel, odds: spreadOdds, onTap: onSpread)),
          const SizedBox(width: 6),
          Expanded(
              flex: 3,
              child: _OddsCell(top: totalLabel, odds: totalOdds, onTap: onTotal)),
          const SizedBox(width: 6),
          Expanded(
              flex: 3, child: _OddsCell(odds: moneyOdds, onTap: onMoney)),
        ],
      ),
    );
  }
}

class _OddsCell extends StatelessWidget {
  final String? top;
  final int odds;
  final VoidCallback onTap;
  const _OddsCell({this.top, required this.odds, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.innerCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (top != null)
              Text(top!,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10.5)),
            Text(
              BoardGame.fmtOdds(odds),
              style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
