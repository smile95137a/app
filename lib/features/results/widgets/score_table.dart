import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/team_logo.dart';
import '../../games/models/game.dart';
import '../../games/models/game_status.dart';

class ScoreTable extends StatelessWidget {
  final Game game;
  const ScoreTable({super.key, required this.game});

  // APK dimens.xml:
  //   scoreboard_component_total_score_min_width: 37dp  ← total column
  //   scoreboard_interval_score_min_height:       20dp  ← score cell rows
  //   scoreboard_interval_label_min_height:       18dp  ← header label row
  static const double _nameW  = 118;
  static const double _colW   = 24;   // regular period column
  static const double _totalW = 37;   // 'T' total column
  static const double _scoreH = 20;   // score cell min-height
  static const double _labelH = 18;   // header label min-height

  @override
  Widget build(BuildContext context) {
    final awayPeriods = game.scorePeriods
        .where((p) => p.teamType == 'AWAY')
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final homePeriods = game.scorePeriods
        .where((p) => p.teamType == 'HOME')
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    if (awayPeriods.isEmpty && homePeriods.isEmpty) {
      return const SizedBox.shrink();
    }

    final headers  = awayPeriods.map((p) => p.periodLabel).toList();
    final totalIdx = headers.indexOf('T');
    final statusLabel = game.status == GameStatus.finalGame
        ? 'Final'
        : game.status.displayText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed left column — status label + team names
          SizedBox(
            width: _nameW,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _labelH,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(statusLabel,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 10)),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: _scoreH,
                  child: _TeamNameRow(game.awayTeam),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  height: _scoreH,
                  child: _TeamNameRow(game.homeTeam),
                ),
              ],
            ),
          ),
          // Scrollable right — headers + scores
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  SizedBox(
                    height: _labelH,
                    child: Row(
                      children: headers.asMap().entries.map((e) {
                        final isTotal = e.key == totalIdx;
                        return SizedBox(
                          width: isTotal ? _totalW : _colW,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              e.value,
                              style: TextStyle(
                                color: isTotal
                                    ? AppColors.warning
                                    : AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: isTotal
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Away scores
                  SizedBox(
                    height: _scoreH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: awayPeriods.asMap().entries.map((e) {
                        final isTotal = e.key == totalIdx;
                        return SizedBox(
                          width: isTotal ? _totalW : _colW,
                          child: Text(
                            '${e.value.score}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isTotal
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                              fontWeight: isTotal
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Home scores
                  SizedBox(
                    height: _scoreH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: homePeriods.asMap().entries.map((e) {
                        final isTotal = e.key == totalIdx;
                        return SizedBox(
                          width: isTotal ? _totalW : _colW,
                          child: Text(
                            '${e.value.score}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isTotal
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                              fontWeight: isTotal
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamNameRow extends StatelessWidget {
  final String teamName;
  const _TeamNameRow(this.teamName);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TeamLogo(teamName: teamName, size: 16),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            teamName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
