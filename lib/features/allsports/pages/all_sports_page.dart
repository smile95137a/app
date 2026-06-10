import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/sports_icon.dart';
import '../../results/widgets/results_header.dart';

class AllSportsPage extends ConsumerWidget {
  final VoidCallback? onLogoTap;
  const AllSportsPage({super.key, this.onLogoTap});

  static const _sports = [
    _SportRow(SportsGlyph.basketball, 'Basketball', 'NBA · NCAAB'),
    _SportRow(SportsGlyph.baseball, 'Baseball', 'MLB · College'),
    _SportRow(SportsGlyph.football, 'Football', 'NFL · NCAAF'),
    _SportRow(SportsGlyph.soccer, 'Soccer', 'EPL · La Liga · MLS'),
    _SportRow(SportsGlyph.hockey, 'Hockey', 'NHL'),
    _SportRow(SportsGlyph.tennis, 'Tennis', 'ATP · WTA'),
    _SportRow(SportsGlyph.boxing, 'Boxing / MMA', 'UFC · Boxing'),
    _SportRow(SportsGlyph.golf, 'Golf', 'PGA · LIV'),
    _SportRow(SportsGlyph.racing, 'Racing', 'NASCAR · F1'),
    _SportRow(SportsGlyph.volleyball, 'Volleyball', 'Beach · Indoor'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: ResultsHeader(onSecretTap: onLogoTap),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: TextField(
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
            cursorColor: AppColors.green,
            decoration: InputDecoration(
              hintText: 'Search sports, teams, events...',
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.textMuted, size: 28),
              filled: true,
              fillColor: AppColors.cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 17),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ALL SPORTS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 80),
            itemCount: _sports.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.divider, height: 1),
            itemBuilder: (_, i) {
              final s = _sports[i];
              return SizedBox(
                height: 90,
                child: Row(
                  children: [
                    SportsIcon(glyph: s.glyph, size: 55),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            s.sub,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted, size: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SportRow {
  final SportsGlyph glyph;
  final String name;
  final String sub;

  const _SportRow(this.glyph, this.name, this.sub);
}
