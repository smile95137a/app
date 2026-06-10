import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/sports_icon.dart';
import '../../results/widgets/results_header.dart';

class RewardsPage extends ConsumerWidget {
  final VoidCallback? onLogoTap;
  const RewardsPage({super.key, this.onLogoTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: ResultsHeader(onSecretTap: onLogoTap),
          ),
        ),
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 390;
              final heroHeight = narrow ? 300.0 : 324.0;
              return Container(
                height: heroHeight,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF18331C), Color(0xFF17371E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.goldBorder, width: 1.6),
                ),
                child: _RewardsHeroContent(compact: narrow),
              );
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _SectionLabel('YOUR TIER'),
              const SizedBox(height: 14),
              const _TierCard(
                name: 'Gold',
                points: 10000,
                nextTier: 'Platinum',
                nextPoints: 25000,
                current: 12450,
                color: AppColors.goldBorder,
              ),
              const SizedBox(height: 28),
              const _SectionLabel('AVAILABLE REWARDS'),
              const SizedBox(height: 14),
              const _RewardItem(title: '\$5 Bonus Bet', cost: '500 pts'),
              const _RewardItem(title: '\$10 Bonus Bet', cost: '1,000 pts'),
              const _RewardItem(title: '\$25 Bonus Bet', cost: '2,500 pts'),
              const _RewardItem(
                  title: 'Free Entry - DK1M Contest',
                  cost: '5,000 pts',
                  ticket: true),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }
}

class _RewardsHeroContent extends StatelessWidget {
  final bool compact;

  const _RewardsHeroContent({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('\u{1F451}',
            style: TextStyle(fontSize: compact ? 48 : 58, height: 1)),
        SizedBox(height: compact ? 16 : 22),
        Text(
          'DK CROWN',
          style: TextStyle(
            color: AppColors.goldBorder,
            fontWeight: FontWeight.w800,
            fontSize: compact ? 25 : 28,
            letterSpacing: 2.4,
          ),
        ),
        SizedBox(height: compact ? 10 : 12),
        Text(
          'REWARDS',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: compact ? 16 : 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 4,
          ),
        ),
        SizedBox(height: compact ? 22 : 26),
        Text(
          '12,450',
          style: TextStyle(
            color: AppColors.green,
            fontSize: compact ? 42 : 48,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Crown Points',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: compact ? 14 : 16,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String name, nextTier;
  final int points, nextPoints, current;
  final Color color;

  const _TierCard({
    required this.name,
    required this.points,
    required this.nextTier,
    required this.nextPoints,
    required this.current,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = ((current - points) / (nextPoints - points)).clamp(0.0, 1.0);
    return Container(
      height: 130,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.48)),
                ),
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              const Spacer(),
              Text(
                '$current pts',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.innerCard,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${nextPoints - current} pts to $nextTier',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String title, cost;
  final bool ticket;

  const _RewardItem(
      {required this.title, required this.cost, this.ticket = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ticket
              ? const Icon(Icons.confirmation_number_rounded,
                  color: AppColors.warning, size: 30)
              : const RewardGiftIcon(size: 32),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.greenDarkBadge,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              cost,
              style: const TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
