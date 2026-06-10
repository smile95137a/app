import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/bet_filter_provider.dart';

class BetStatusTabs extends ConsumerWidget {
  const BetStatusTabs({super.key});

  static const _visibleTabs = [
    BetTab.open,
    BetTab.live,
    BetTab.settled,
    BetTab.won,
    BetTab.lost,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(selectedBetTabProvider);
    return SizedBox(
      height: 38,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        children: [
          // Filter icon — APK: ic_filter.xml (sliders icon, colored via tint)
          Center(
            child: SvgPicture.asset(
              'assets/icons/filter.svg',
              width: 20,
              height: 15,
              colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary, BlendMode.srcIn),
            ),
          ),
          // Divider — APK: mybets_filter_divider.xml (2dp × 36dp, #6f6f6f)
          Center(
            child: Container(
              width: 2,
              height: 36,
              margin: const EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6F6F6F),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          ..._visibleTabs.map((tab) => _TabPill(tab, current, ref)),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final BetTab tab;
  final BetTab current;
  final WidgetRef ref;

  const _TabPill(this.tab, this.current, this.ref);

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == current;
    return GestureDetector(
      onTap: () => ref.read(selectedBetTabProvider.notifier).state = tab,
      child: Container(
        margin: const EdgeInsets.only(left: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          // APK: searchbar_border_color = #424242 (inactive), white (active)
          // APK: border_width = 1dp
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF424242),
            width: 1.0,
          ),
        ),
        child: Text(
          tab.label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFFABABAB),
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 1,
          ),
        ),
      ),
    );
  }
}
