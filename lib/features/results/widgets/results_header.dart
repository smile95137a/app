import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/money_formatter.dart';
import '../../balance/providers/balance_provider.dart';

class ResultsHeader extends ConsumerWidget {
  final VoidCallback? onSecretTap;
  final bool appMyBetsStyle;

  const ResultsHeader({
    super.key,
    this.onSecretTap,
    this.appMyBetsStyle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    if (appMyBetsStyle) {
      return _AppMyBetsHeader(
        amount: formatMoney(balance.balance),
        onSecretTap: onSecretTap,
      );
    }

    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onSecretTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/reference/header_dk_app.png',
                    width: 28,
                    height: 28,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/images/reference/header_rg_badge.png',
                    width: 20,
                    height: 20,
                    filterQuality: FilterQuality.high,
                  ),
                ],
              ),
            ),
            const Spacer(),
            _BalanceDeposit(amount: formatMoney(balance.balance)),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/reference/header_bell.png',
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/reference/header_profile.png',
              width: 28,
              height: 28,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppMyBetsHeader extends StatelessWidget {
  final String amount;
  final VoidCallback? onSecretTap;

  const _AppMyBetsHeader({required this.amount, this.onSecretTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onSecretTap,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CustomPaint(painter: _MenuPainter()),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'My Bets',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/reference/header_rg_badge.png',
            width: 22,
            height: 22,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 8),
          _BalanceDeposit(amount: amount),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/reference/header_profile.png',
            width: 28,
            height: 28,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}

class _MenuPainter extends CustomPainter {
  const _MenuPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;
    const left = 1.0;
    final right = size.width - 1;
    canvas.drawLine(const Offset(1, 5), Offset(right, 5), paint);
    canvas.drawLine(
        Offset(left, size.height / 2), Offset(right, size.height / 2), paint);
    canvas.drawLine(
        Offset(left, size.height - 5), Offset(right, size.height - 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BalanceDeposit extends StatelessWidget {
  final String amount;

  const _BalanceDeposit({required this.amount});

  @override
  Widget build(BuildContext context) {
    // APK dimens: balancepill_content_vertical_padding=6dp,
    //             balancepill_plus_icon_size=18dp,
    //             balancepill_plus_icon_padding=3dp
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // APK: surfaceNav = #242424 (lobby_nav_bar_local_button_color)
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            // APK: balancepill_plus_icon_size = 18dp
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.green, width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Text(
              '+',
              style: TextStyle(
                color: AppColors.green,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 0.95,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
