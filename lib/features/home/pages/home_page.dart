import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../results/widgets/results_header.dart';

class HomePage extends ConsumerWidget {
  final VoidCallback? onLogoTap;
  const HomePage({super.key, this.onLogoTap});

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
          child: _PromosBanner(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionLabel('FEATURED'),
              const SizedBox(height: 10),
              _FeaturedCard(
                sport: 'NBA',
                home: 'Boston Celtics',
                away: 'NY Knicks',
                time: '7:30 PM ET',
                homeOdds: '-115',
                awayOdds: '-105',
              ),
              const SizedBox(height: 10),
              _FeaturedCard(
                sport: 'MLB',
                home: 'NY Yankees',
                away: 'Boston Red Sox',
                time: '6:05 PM ET',
                homeOdds: '-130',
                awayOdds: '+110',
              ),
              const SizedBox(height: 10),
              _FeaturedCard(
                sport: 'Soccer',
                home: 'Arsenal',
                away: 'Chelsea',
                time: '3:00 PM ET',
                homeOdds: '+140',
                awayOdds: '+180',
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }
}

class _PromosBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2E1A), Color(0xFF243F24)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BET \$5, GET \$150',
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'In Bonus Bets if your first bet wins',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
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
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String sport, home, away, time, homeOdds, awayOdds;
  const _FeaturedCard({
    required this.sport,
    required this.home,
    required this.away,
    required this.time,
    required this.homeOdds,
    required this.awayOdds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.innerCard,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sport,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(away,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(home,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],
                ),
              ),
              Column(
                children: [
                  _OddsButton(awayOdds),
                  const SizedBox(height: 6),
                  _OddsButton(homeOdds),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OddsButton extends StatelessWidget {
  final String odds;
  const _OddsButton(this.odds);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        odds,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
