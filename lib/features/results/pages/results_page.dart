import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/bet_filter_provider.dart';
import '../widgets/results_header.dart';
import '../widgets/bet_status_tabs.dart';
import '../widgets/bet_card.dart';
import '../widgets/empty_bet_view.dart';

class ResultsPage extends ConsumerStatefulWidget {
  final VoidCallback? onLogoTap;

  const ResultsPage({super.key, this.onLogoTap});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    final bets = ref.watch(filteredBetsProvider);
    final tab = ref.watch(selectedBetTabProvider);
    final tabLabel = tab.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: ResultsHeader(
            onSecretTap: widget.onLogoTap,
            appMyBetsStyle: true,
          ),
        ),
        const _SectionTabBar(),
        const SizedBox(height: 10),
        const BetStatusTabs(),
        Expanded(
          child: bets.isEmpty
              ? EmptyBetView(tab: tabLabel)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 112),
                  itemCount: bets.length,
                  itemBuilder: (_, i) => BetCard(bet: bets[i]),
                ),
        ),
      ],
    );
  }
}

class _SectionTabBar extends StatelessWidget {
  const _SectionTabBar();

  static const _tabs = [
    'My Bets',
    'My Horse Bets',
    'Betting Groups',
    'My Pools',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final isActive = entry.key == 0;
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        entry.value,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: isActive ? AppColors.green : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Container(height: 1, color: AppColors.divider),
      ],
    );
  }
}
