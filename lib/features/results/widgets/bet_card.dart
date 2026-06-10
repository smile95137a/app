import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../widgets/dk_logo.dart';
import '../../../widgets/team_logo.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
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
        return _WonCard(bet: bet, game: game);
      case BetStatus.open:
        return _OpenCard(bet: bet, game: game);
      case BetStatus.lost:
      case BetStatus.voided:
        return _SettledCard(bet: bet, game: game);
    }
  }
}

// ─────────────────────────────────────────────
// WON card — gold border + confetti + DK logo
// ─────────────────────────────────────────────
class _WonCard extends StatelessWidget {
  final BetSlip bet;
  final dynamic game;
  const _WonCard({required this.bet, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Same horizontal margin as all other cards — consistent layout grid
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        // APK bg_won_asset.xml palette: warm multi-stop metallic gold
        gradient: const LinearGradient(
          colors: [
            Color(0xFFC4980E), // warm muted gold
            Color(0xFFF7D002), // bright peak — bg_won_asset primary fill
            Color(0xFF8A6B0A), // dark amber end
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(1.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.5),
        child: Container(
          color: AppColors.cardBg,
          child: Stack(
            children: [
              const _ConfettiOverlay(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 9, 14, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DkLogo(height: 14),
                        const CrownIsYours(fontSize: 7.5),
                      ],
                    ),
                  ),
                  _SelectionRow(
                    bet: bet,
                    showIcon: bet.sportType != SportType.soccer &&
                        !bet.selectionName.toLowerCase().startsWith('under') &&
                        !bet.selectionName.toLowerCase().startsWith('over') &&
                        !bet.selectionName.toLowerCase().contains('parlay'),
                  ),
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
                    child: Row(children: [
                      _Amount('Wager:', formatMoney(bet.wagerAmount)),
                      const SizedBox(width: 8),
                      const Text('|',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 13)),
                      const SizedBox(width: 8),
                      _Amount('Paid:', formatMoney(bet.paidAmount)),
                    ]),
                  ),
                  if (bet.selectionName.toLowerCase().contains('parlay')) ...[
                    const SizedBox(height: 9),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: _ParlayLegRow(),
                    ),
                  ],
                  if (game != null) ...[
                    const SizedBox(height: 9),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ScoreTable(game: game),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.divider, height: 1),
                  const _ShareRow(),
                  _FooterRow(bet: bet),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParlayLegRow extends StatelessWidget {
  const _ParlayLegRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // APK: ic_bet_status_green_check.xml — 12dp circle with checkmark
        SvgPicture.asset(
          'assets/icons/status_won.svg',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
              AppColors.green, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        TeamLogo(teamName: 'LA Dodgers', size: 18),
        const SizedBox(width: 6),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LA Dodgers -1.5',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Run Line',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 9),
              ),
            ],
          ),
        ),
        const Text(
          '-173',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 9),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// LOST / VOIDED card — plain dark card
// ─────────────────────────────────────────────
class _SettledCard extends StatelessWidget {
  final BetSlip bet;
  final dynamic game;
  const _SettledCard({required this.bet, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        // APK: bg_shimmer_position_card.xml strokeAlpha=0.08 white border
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
              child: ScoreTable(game: game),
            ),
          ],
          const SizedBox(height: 9),
          const Divider(color: AppColors.divider, height: 1),
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
  final dynamic game;
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
                    style:
                        TextStyle(color: AppColors.textMuted, fontSize: 12)),
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
              _SharePill(),
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
  final dynamic game;
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
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
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
    final away = game?.awayTeam as String? ?? '';
    final home = game?.homeTeam as String? ?? '';
    final startTime = game?.startTime as DateTime?;
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

  // APK status icon path based on bet result
  String get _statusIconAsset {
    switch (bet.resultStatus) {
      case BetStatus.won:    return 'assets/icons/status_won.svg';
      case BetStatus.lost:   return 'assets/icons/status_lost.svg';
      case BetStatus.voided: return 'assets/icons/status_voided.svg';
      case BetStatus.open:   return 'assets/icons/status_open.svg';
    }
  }

  // Status color — uses existing BetStatus token
  Color get _statusColor => bet.resultStatus.badgeTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            TeamLogo(teamName: bet.selectionName, size: 28),
            const SizedBox(width: 7),
          ],
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: [
                TextSpan(
                  text: bet.selectionDisplay,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: '  ',
                  style: TextStyle(fontSize: 12),
                ),
                TextSpan(
                  text: bet.oddsDisplay,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          // APK-style status indicator: circle icon + label, no fill background
          // Source: ic_bet_status_*.xml (12dp stroke circle icons)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                _statusIconAsset,
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(_statusColor, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                bet.resultStatus.displayText,
                style: TextStyle(
                  color: _statusColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.5,
                ),
              ),
            ],
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
                color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Single share row — used in Won and Settled cards
class _ShareRow extends StatelessWidget {
  const _ShareRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 9, 14, 6),
      child: Row(children: [_SharePill()]),
    );
  }
}

class _SharePill extends StatelessWidget {
  const _SharePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        // APK: searchbar_border_color = #424242
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF424242), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // APK: dk_share_24.xml — actual DK share/export arrow icon
          SvgPicture.asset(
            'assets/icons/share.svg',
            width: 15,
            height: 15,
            colorFilter: const ColorFilter.mode(
                AppColors.textSecondary, BlendMode.srcIn),
          ),
          const SizedBox(width: 5),
          const Text(
            'Share',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_clock_outlined,
              color: AppColors.textSecondary, size: 12),
          SizedBox(width: 5),
          Text(
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
              style: const TextStyle(color: AppColors.textMuted, fontSize: 7),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Placed: ${formatPlacedTime(bet.placedAt)}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 7),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Confetti overlay (Won cards only)
// APK palette: bg_won_assert_rva.xml primary = #f7d002
// ─────────────────────────────────────────────
class _ConfettiOverlay extends StatefulWidget {
  const _ConfettiOverlay();

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) =>
              CustomPaint(painter: _ConfettiPainter(_ctrl.value)),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  _ConfettiPainter(this.t);

  // APK gold palette from bg_won_assert_rva.xml (#f7d002) and bg_won_asset.xml
  // All y <= 0.35 — sparkles stay in upper portion matching DK reference
  static const _pts = [
    (x: 0.05, y: 0.02, s: 0.007, r: 4.5, c: Color(0xFFF7D002)),
    (x: 0.15, y: 0.08, s: 0.005, r: 3.0, c: Color(0xFFD6A10A)),
    (x: 0.28, y: 0.01, s: 0.008, r: 5.0, c: Color(0xFFF7D002)),
    (x: 0.42, y: 0.06, s: 0.004, r: 2.5, c: Color(0xFFEDD251)),
    (x: 0.57, y: 0.03, s: 0.007, r: 4.0, c: Color(0xFFF7D002)),
    (x: 0.70, y: 0.09, s: 0.005, r: 3.0, c: Color(0xFFD6A10A)),
    (x: 0.83, y: 0.04, s: 0.009, r: 4.5, c: Color(0xFFF7BF2D)),
    (x: 0.93, y: 0.12, s: 0.006, r: 2.5, c: Color(0xFFF7D002)),
    (x: 0.10, y: 0.25, s: 0.004, r: 3.0, c: Color(0xFFEDD251)),
    (x: 0.50, y: 0.20, s: 0.007, r: 3.5, c: Color(0xFFD6A10A)),
    (x: 0.75, y: 0.30, s: 0.005, r: 3.0, c: Color(0xFFF7D002)),
    (x: 0.88, y: 0.18, s: 0.008, r: 4.0, c: Color(0xFFEF8C34)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pts) {
      final py = ((p.y + t * p.s * 12) % 1.0) * size.height;
      final paint = Paint()
        ..color = p.c.withValues(alpha: 0.55)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x * size.width, py), p.r, paint);

      final py2 = ((p.y + t * p.s * 12 + 0.5) % 1.0) * size.height;
      paint.color = p.c.withValues(alpha: 0.28);
      canvas.drawCircle(Offset(p.x * size.width, py2), p.r * 0.55, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
