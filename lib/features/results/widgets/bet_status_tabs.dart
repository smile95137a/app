import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/bet_filter_provider.dart';

class BetStatusTabs extends ConsumerWidget {
  const BetStatusTabs({super.key});

  static const _visibleTabs = [
    BetTab.all,
    BetTab.cashOut,
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
      height: 42,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          Center(child: _FilterButton(showBadge: current != BetTab.all)),
          Center(
            child: Container(
              width: 2,
              height: 32,
              margin: const EdgeInsets.only(left: 12, right: 1),
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

class _FilterButton extends StatelessWidget {
  final bool showBadge;
  const _FilterButton({required this.showBadge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 33,
          height: 33,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/filter.svg',
            width: 18,
            height: 14,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
        if (showBadge)
          Positioned(
            right: -4,
            top: -5,
            child: Container(
              width: 19,
              height: 19,
              decoration: const BoxDecoration(
                color: Color(0xFFE21F35),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
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
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF424242),
            width: 1,
          ),
        ),
        child: Text(
          tab.label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFFABABAB),
            fontWeight: FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0,
            height: 1,
          ),
        ),
      ),
    );
  }
}
