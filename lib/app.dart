import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/board/pages/betting_board_page.dart';
import 'features/live/pages/live_page.dart';
import 'features/results/pages/results_page.dart';
import 'features/allsports/pages/all_sports_page.dart';
import 'features/rewards/pages/rewards_page.dart';
import 'features/admin/pages/admin_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MockKingsApp extends StatelessWidget {
  const MockKingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DraftKings',
      theme: AppTheme.dark,
      home: const _RootShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell();

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _index = 2;
  int _logoTapCount = 0;
  DateTime? _lastLogoTap;

  static bool get _isRealMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastLogoTap != null &&
        now.difference(_lastLogoTap!) > const Duration(seconds: 3)) {
      _logoTapCount = 0;
    }
    _lastLogoTap = now;
    _logoTapCount++;
    if (_logoTapCount < 5) return;

    _logoTapCount = 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _AdminShell(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BettingBoardPage(onLogoTap: _onLogoTap),
      LivePage(onLogoTap: _onLogoTap),
      ResultsPage(onLogoTap: _onLogoTap),
      AllSportsPage(onLogoTap: _onLogoTap),
      RewardsPage(onLogoTap: _onLogoTap),
    ];

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _DkBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );

    if (_isRealMobile) return scaffold;

    return Container(
      color: const Color(0xFFE9EDF3),
      alignment: Alignment.topCenter,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 402,
          height: 874,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: Column(
              children: [
                const _PhoneStatusBar(),
                Expanded(child: scaffold),
                const _PhoneHomeIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DkBottomNav({required this.currentIndex, required this.onTap});

  static const _labels = ['Home', 'Live', 'My Bets', 'Search', 'Rewards'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 0.5)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 56, // APK dimens.xml: dk_nav_bar_height = 56dp
        child: Row(
          children: List.generate(5, (i) {
            final selected = i == currentIndex;
            final color = selected ? AppColors.green : const Color(0xFF808080);
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavIcon(index: i, color: color),
                    const SizedBox(height: 2),
                    Text(
                      _labels[i],
                      style: TextStyle(
                        color: color,
                        fontSize: 9.5,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final int index;
  final Color color;

  const _NavIcon({required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    final name = switch (index) {
      0 => 'nav_home',
      1 => 'nav_live',
      2 => 'nav_mybets',
      3 => 'nav_search',
      4 => 'nav_rewards',
      _ => 'nav_home',
    };

    final icon = SvgPicture.asset(
      'assets/icons/$name.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

    if (index != 1) return icon;

    return SizedBox(
      width: 32,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: icon),
          Positioned(
            right: -4,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFE21F35),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Text(
                '80',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  const _PhoneStatusBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: Stack(
        children: [
          const Positioned(
            left: 42,
            top: 18,
            child: Text(
              '4:52',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 144,
            top: 12,
            child: Container(
              width: 135,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Align(
                alignment: const Alignment(-0.84, -0.1),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB90F21),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            right: 62,
            top: 19,
            child: Icon(Icons.signal_cellular_alt_rounded,
                color: Colors.white, size: 14),
          ),
          const Positioned(
            right: 38,
            top: 18,
            child: Text(
              '5G',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 18,
            child: Container(
              width: 17,
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 12,
                  margin: const EdgeInsets.all(1),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneHomeIndicator extends StatelessWidget {
  const _PhoneHomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: AppColors.background,
      alignment: Alignment.center,
      child: Container(
        width: 132,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _AdminShell extends StatelessWidget {
  const _AdminShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Admin Panel',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.divider),
        ),
      ),
      body: const AdminPage(),
    );
  }
}
