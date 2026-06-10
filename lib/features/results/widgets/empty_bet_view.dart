import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class EmptyBetView extends StatelessWidget {
  final String tab;
  const EmptyBetView({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_score_outlined, color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text(
            'No $tab bets yet',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add bets in the Admin tab',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
