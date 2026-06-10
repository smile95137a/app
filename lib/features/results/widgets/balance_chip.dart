import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/money_formatter.dart';
import '../../balance/providers/balance_provider.dart';

class BalanceChip extends ConsumerWidget {
  const BalanceChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.greenDarkBadge,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        formatMoney(balance.balance),
        style: const TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}
