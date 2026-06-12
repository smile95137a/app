import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../widgets/team_logo.dart';
import '../../../widgets/soccer_kit_icon.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
import '../../bets/models/parlay_leg.dart';
import '../../games/models/game.dart';
import '../../games/models/sport_type.dart';
import '../../games/providers/game_provider.dart';
import 'score_table.dart';

class BetCard extends ConsumerWidget {
  final BetSlip bet;
  const BetCard({super.key, required this.bet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameProvider);
    final game = games.where((g) => g.id == bet.gameId).firstOrNull;

    switch (bet.resultStatus) {
      case BetStatus.won:
        return _WonCard(bet: bet, game: game, games: games);
      case BetStatus.open:
        return _OpenCard(bet: bet, game: game);
      case BetStatus.lost:
      case BetStatus.voided:
        return _SettledCard(bet: bet, game: game);
    }
  }
}

// ─────────────────────────────────────────────
// WON card
// Gold texture fills outer bounds; dark content inset asymmetric (bottom 8px).
// ─────────────────────────────────────────────
class _WonCard extends StatelessWidget {
  final BetSlip bet;
  final Game? game;
  final List<Game> games;
  const _WonCard({required this.bet, required this.game, required this.games});

  @override
  Widget build(BuildContext context) {
    final hasLegs = bet.legs != null && bet.legs!.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/gold_border_bet_card.webp',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: AppColors.cardBg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _WinnerHeader(),
                      const SizedBox(height: 4),
                      _SelectionRow(
                        bet: bet,
                        showIcon: !bet.selectionName
                                .toLowerCase()
                                .startsWith('under') &&
                            !bet.selectionName
                                .toLowerCase()
                                .startsWith('over') &&
                            !bet.selectionName.toLowerCase().contains('parlay'),
                      ),
                      const SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          bet.betType,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            _Amount('Wager:', formatMoney(bet.wagerAmount)),
                            const SizedBox(width: 8),
                            const Text(
                              '|',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _Amount('Paid:', formatMoney(bet.paidAmount)),
                          ],
                        ),
                      ),
                      if (hasLegs) ...[
                        const SizedBox(height: 5),
                        const Divider(color: AppColors.divider, height: 1),
                        ...bet.legs!.map(
                          (leg) => _ParlayLegDetailRow(
                            leg: leg,
                            games: games,
                          ),
                        ),
                      ] else if (game != null) ...[
                        const SizedBox(height: 9),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: ScoreTable(game: game!),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (!hasLegs) const SizedBox(height: 10),
                      const Divider(
                        color: Color(0xFF343436),
                        height: 1,
                        thickness: 1,
                      ),
                      const _ShareRow(),
                      _FooterRow(bet: bet),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParlayLegDetailRow extends StatelessWidget {
  final ParlayLeg leg;
  final List<Game> games;
  const _ParlayLegDetailRow({required this.leg, required this.games});

  @override
  Widget build(BuildContext context) {
    final Game? game = games.where((g) => g.id == leg.gameId).firstOrNull;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: AppColors.greenDarkBadge,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.green, width: 1),
                ),
                child:
                    const Icon(Icons.check, color: AppColors.green, size: 11),
              ),
              const SizedBox(width: 6),
              TeamLogo(teamName: leg.selectionName, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            leg.selectionDisplay,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          leg.oddsDisplay,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      leg.betType,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (game != null) ...[
            const SizedBox(height: 8),
            ScoreTable(game: game),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOST / VOIDED card
// ─────────────────────────────────────────────
class _SettledCard extends StatelessWidget {
  final BetSlip bet;
  final Game? game;
  const _SettledCard({required this.bet, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _SelectionRow(bet: bet, showIcon: true),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(bet.betType,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ),
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _Amount('Wager:', formatMoney(bet.wagerAmount)),
          ),
          if (game != null) ...[
            const SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ScoreTable(game: game!),
            ),
          ],
          const SizedBox(height: 9),
          const Divider(
            color: Color(0xFF343436),
            height: 1,
            thickness: 1,
          ),
          const _ShareRow(),
          _FooterRow(bet: bet),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OPEN card
// ─────────────────────────────────────────────
class _OpenCard extends StatelessWidget {
  final BetSlip bet;
  final Game? game;
  const _OpenCard({required this.bet, required this.game});

  bool get _isSoccer => bet.sportType == SportType.soccer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _SelectionRow(
            bet: bet,
            showIcon: !bet.selectionName.toLowerCase().startsWith('under') &&
                !bet.selectionName.toLowerCase().startsWith('over') &&
                !bet.selectionName.toLowerCase().contains('parlay'),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              bet.betType,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (_isSoccer) ...[
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Market settled based on the result at the end of regular time (including injury time/stoppage time). Extra time and penalty shoot-outs are not included.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 8.5,
                  height: 1.25,
                ),
              ),
            ),
          ],
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _Amount('Wager:', formatMoney(bet.wagerAmount)),
                const SizedBox(width: 8),
                const Text('|',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(width: 8),
                _Amount('To Pay:', formatMoney(bet.paidAmount)),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.innerCard,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sync_rounded,
                        size: 12, color: AppColors.textPrimary),
                    SizedBox(width: 5),
                    Text(
                      'Reuse Selections',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _OpenMatchupRow(game: game),
          ),
          const SizedBox(height: 9),
          const Divider(color: AppColors.divider, height: 1),
          const Padding(
            padding: EdgeInsets.only(top: 7, left: 14, right: 14),
            child: Row(children: [
              _SharePill(framed: true),
              SizedBox(width: 8),
              _LockPill(),
            ]),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _FooterRow(bet: bet, compact: true),
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
  }
}

class _OpenMatchupRow extends StatelessWidget {
  final Game? game;
  const _OpenMatchupRow({required this.game});

  static String _fmtDate(DateTime? dt) {
    if (dt == null) return 'TBD';
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final m = dt.minute.toString().padLeft(2, '0');
      return 'Today $h:$m ${dt.hour >= 12 ? "PM" : "AM"}';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final d = dt.day;
    final suffix = (d % 10 == 1 && d != 11)
        ? 'st'
        : (d % 10 == 2 && d != 12)
            ? 'nd'
            : (d % 10 == 3 && d != 13)
                ? 'rd'
                : 'th';
    return '${months[dt.month - 1]} $d$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final away = game?.awayTeam ?? '';
    final home = game?.homeTeam ?? '';
    final startTime = game?.startTime;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (away.isNotEmpty) ...[
            TeamLogo(teamName: away, size: 16),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              away,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _fmtDate(startTime),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
          ),
          Expanded(
            child: Text(
              home,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (home.isNotEmpty) ...[
            const SizedBox(width: 6),
            TeamLogo(teamName: home, size: 16),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────

class _SelectionRow extends StatelessWidget {
  final BetSlip bet;
  final bool showIcon;
  const _SelectionRow({required this.bet, required this.showIcon});

  Color get _statusColor => bet.resultStatus.badgeTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            if (bet.sportType == SportType.soccer)
              SoccerKitIcon(teamName: bet.selectionName, size: 32)
            else
              TeamLogo(teamName: bet.selectionName, size: 28),
            const SizedBox(width: 7),
          ],
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    bet.selectionDisplay,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    '|',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Text(
                  bet.oddsDisplay,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: bet.resultStatus.badgeBgColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              bet.resultStatus.displayText,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  final String label;
  final String value;
  const _Amount(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.15)),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.15)),
      ],
    );
  }
}

class _WinnerHeader extends StatelessWidget {
  const _WinnerHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/images/mybets_winner_header.svg',
        fit: BoxFit.fill,
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 10, 14, 7),
      child: Row(children: [_SharePill(framed: true)]),
    );
  }
}

class _SharePill extends StatelessWidget {
  final bool framed;
  const _SharePill({this.framed = false});

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.textPrimary;
    return Container(
      constraints: framed
          ? const BoxConstraints(minWidth: 66, minHeight: 26)
          : const BoxConstraints(),
      decoration: framed
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF424242).withValues(alpha: 0.58),
                width: 1.0,
              ),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: framed ? 8 : 0,
          vertical: framed ? 0 : 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (framed)
              Image.asset(
                'assets/icons/share_native.png',
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              )
            else
              SvgPicture.asset(
                'assets/icons/share.svg',
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            SizedBox(width: framed ? 4 : 5),
            Text(
              'Share',
              style: TextStyle(
                color: iconColor,
                fontSize: framed ? 12 : 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockPill extends StatelessWidget {
  const _LockPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF424242), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/clock.svg',
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(
                AppColors.textSecondary, BlendMode.srcIn),
          ),
          const SizedBox(width: 5),
          const Text(
            'Track on Lock Screen',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterRow extends StatelessWidget {
  final BetSlip bet;
  final bool compact;
  const _FooterRow({required this.bet, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          compact ? 0 : 14, 0, compact ? 0 : 14, compact ? 0 : 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Bet ID: ${bet.betCode}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 8,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Placed: ${formatPlacedTime(bet.placedAt)}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Won card crown text
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// Static confetti — 3D gold crown particles at very top of Won card only
// Uses ic_crown_particle.png (3D gold crown image)
// ─────────────────────────────────────────────
