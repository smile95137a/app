import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/dk_sync_service.dart';
import '../../../storage/seed_data.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/providers/bet_provider.dart';
import '../../board/providers/board_provider.dart';
import '../../games/models/game.dart';
import '../../games/providers/game_provider.dart';
import 'balance_form_page.dart';
import 'bet_form_page.dart';
import 'game_form_page.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bets = ref.watch(betProvider);
    final games = ref.watch(gameProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(bottom: false, child: SizedBox(height: 8)),
          const Text(
            '後台管理',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          _MenuCard(
            icon: Icons.sync_rounded,
            title: '同步今日賽事',
            subtitle: '抓取今日賽事並更新下注盤口',
            color: AppColors.green,
            onTap: () => _syncTodayBoard(context, ref),
          ),
          _MenuCard(
            icon: Icons.account_balance_wallet,
            title: '帳戶餘額設定',
            subtitle: '更新您的帳戶餘額',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BalanceFormPage()),
            ),
          ),
          _MenuCard(
            icon: Icons.add_circle_outline,
            title: '新增比賽',
            subtitle: '手動建立比賽項目',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameFormPage()),
            ),
          ),
          _MenuCard(
            icon: Icons.receipt_long,
            title: '新增投注',
            subtitle: '新增一筆投注單',
            color: AppColors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BetFormPage()),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '投注單',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...bets.map((b) => _BetListItem(bet: b)),
          const SizedBox(height: 16),
          const Text(
            '比賽',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...games.map((g) => _GameListItem(game: g)),
          const SizedBox(height: 20),
          _ActionButton(
            label: '載入範例資料',
            icon: Icons.data_array,
            color: AppColors.warning,
            onTap: () => _seedData(context, ref),
          ),
          const SizedBox(height: 8),
          _ActionButton(
            label: '清除全部資料',
            icon: Icons.delete_forever,
            color: AppColors.danger,
            onTap: () => _clearAll(context, ref),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _syncTodayBoard(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        backgroundColor: AppColors.cardBg,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.green),
            SizedBox(width: 16),
            Text(
              '正在同步今日賽事...',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );

    try {
      final boardGames = await DkSyncService().fetchBoardGames();

      if (!context.mounted) return;
      Navigator.pop(context);

      if (boardGames.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('沒有取得今日賽事，請確認網路或 VPN'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: const Text('確認同步'),
          content: Text(
            '取得 ${boardGames.length} 場今日賽事。要更新後台比賽與下注盤口嗎？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('同步'),
            ),
          ],
        ),
      );

      if (confirm != true || !context.mounted) return;

      await ref.read(boardRepositoryProvider).replaceAll(boardGames);
      ref.invalidate(boardProvider);

      final now = DateTime.now();
      for (final bg in boardGames) {
        await ref.read(gameProvider.notifier).add(
              Game(
                id: bg.id,
                sportType: bg.sport,
                league: bg.league,
                homeTeam: bg.homeTeam,
                awayTeam: bg.awayTeam,
                startTime: bg.startTime,
                status: bg.status,
                scorePeriods: const [],
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已同步 ${boardGames.length} 場今日賽事'),
            backgroundColor: AppColors.greenDarkBadge,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('同步失敗：$e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _seedData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('載入範例資料'),
        content: const Text('這會加入範例比賽與投注單，確定要繼續嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('載入'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    for (final g in SeedData.games) {
      await ref.read(gameProvider.notifier).add(g);
    }
    for (final b in SeedData.bets) {
      await ref.read(betProvider.notifier).add(b);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('範例資料已載入'),
          backgroundColor: AppColors.greenDarkBadge,
        ),
      );
    }
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('清除全部資料'),
        content: const Text('這會刪除全部投注單、比賽與同步盤口，確定嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清除'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await ref.read(betProvider.notifier).clearAll();
    await ref.read(gameProvider.notifier).clearAll();
    await ref.read(boardRepositoryProvider).clearAll();
    ref.invalidate(boardProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('全部資料已清除'),
          backgroundColor: AppColors.dangerDark,
        ),
      );
    }
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _BetListItem extends StatelessWidget {
  final BetSlip bet;

  const _BetListItem({required this.bet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Text(
          bet.selectionDisplay,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${bet.betType} | ${bet.oddsDisplay} | \$${bet.wagerAmount.toStringAsFixed(2)}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bet.resultStatus.badgeBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            bet.resultStatus.displayText,
            style: TextStyle(
              color: bet.resultStatus.badgeTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BetFormPage(editBet: bet)),
        ),
      ),
    );
  }
}

class _GameListItem extends StatelessWidget {
  final Game game;

  const _GameListItem({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Text(
          game.displayName,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${game.sportType.displayText} | ${game.status.displayText}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        trailing: const Icon(Icons.edit, color: AppColors.textMuted, size: 18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameFormPage(editGame: game)),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: color),
        label: Text(label, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onTap,
      ),
    );
  }
}
