import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../results/widgets/results_header.dart';

class LivePage extends ConsumerWidget {
  final VoidCallback? onLogoTap;
  const LivePage({super.key, this.onLogoTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: ResultsHeader(onSecretTap: onLogoTap),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE NOW',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _LiveCard(
                sport: 'NBA',
                home: 'Miami Heat',
                away: 'Chicago Bulls',
                homeScore: 87,
                awayScore: 82,
                period: 'Q3 8:24',
                homeOdds: '-160',
                awayOdds: '+135',
              ),
              const SizedBox(height: 10),
              _LiveCard(
                sport: 'MLB',
                home: 'LA Dodgers',
                away: 'SF Giants',
                homeScore: 4,
                awayScore: 3,
                period: 'BOT 7th',
                homeOdds: '-175',
                awayOdds: '+150',
              ),
              const SizedBox(height: 10),
              _LiveCard(
                sport: 'Soccer',
                home: 'Liverpool',
                away: 'Man City',
                homeScore: 1,
                awayScore: 1,
                period: '72\'',
                homeOdds: '+220',
                awayOdds: '+240',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveCard extends StatelessWidget {
  final String sport, home, away, period, homeOdds, awayOdds;
  final int homeScore, awayScore;
  const _LiveCard({
    required this.sport,
    required this.home,
    required this.away,
    required this.homeScore,
    required this.awayScore,
    required this.period,
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(sport,
                        style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(period,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(away,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text(home,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('$awayScore',
                      style: const TextStyle(
                          color: AppColors.warning, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text('$homeScore',
                      style: const TextStyle(
                          color: AppColors.warning, fontWeight: FontWeight.w800, fontSize: 18)),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  _OddsBtn(awayOdds),
                  const SizedBox(height: 6),
                  _OddsBtn(homeOdds),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OddsBtn extends StatelessWidget {
  final String odds;
  const _OddsBtn(this.odds);

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
          fontSize: 13,
        ),
      ),
    );
  }
}
