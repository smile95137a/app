import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../games/models/game.dart';
import '../../games/models/game_status.dart';
import '../../games/models/score_period.dart';
import '../../games/models/sport_type.dart';
import '../../games/providers/game_provider.dart';

class GameFormPage extends ConsumerStatefulWidget {
  final Game? editGame;
  const GameFormPage({super.key, this.editGame});

  @override
  ConsumerState<GameFormPage> createState() => _GameFormPageState();
}

class _GameFormPageState extends ConsumerState<GameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late SportType _sport;
  late GameStatus _status;
  late final TextEditingController _league;
  late final TextEditingController _home;
  late final TextEditingController _away;
  late List<Map<String, TextEditingController>> _scoreRows;

  @override
  void initState() {
    super.initState();
    final g = widget.editGame;
    _sport = g?.sportType ?? SportType.nba;
    _status = g?.status ?? GameStatus.scheduled;
    _league = TextEditingController(text: g?.league ?? '');
    _home = TextEditingController(text: g?.homeTeam ?? '');
    _away = TextEditingController(text: g?.awayTeam ?? '');
    _initScoreRows(g);
  }

  void _initScoreRows(Game? g) {
    final periods = _sport.defaultPeriods;
    if (g != null && g.scorePeriods.isNotEmpty) {
      final awayPeriods = g.scorePeriods.where((p) => p.teamType == 'AWAY').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      final homePeriods = g.scorePeriods.where((p) => p.teamType == 'HOME').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      _scoreRows = periods.asMap().entries.map((e) {
        final awayScore = awayPeriods.length > e.key ? awayPeriods[e.key].score : 0;
        final homeScore = homePeriods.length > e.key ? homePeriods[e.key].score : 0;
        return {
          'label': TextEditingController(text: e.value),
          'away': TextEditingController(text: '$awayScore'),
          'home': TextEditingController(text: '$homeScore'),
        };
      }).toList();
    } else {
      _scoreRows = periods.asMap().entries.map((e) => {
            'label': TextEditingController(text: e.value),
            'away': TextEditingController(text: '0'),
            'home': TextEditingController(text: '0'),
          }).toList();
    }
  }

  @override
  void dispose() {
    _league.dispose();
    _home.dispose();
    _away.dispose();
    for (final r in _scoreRows) {
      for (var c in r.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editGame == null ? '新增比賽' : '編輯比賽'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('運動類型'),
              DropdownButtonFormField<SportType>(
                initialValue: _sport,
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(),
                items: SportType.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.displayText)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _sport = v;
                    _initScoreRows(null);
                  });
                },
              ),
              const SizedBox(height: 16),
              _label('比賽狀態'),
              DropdownButtonFormField<GameStatus>(
                initialValue: _status,
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(),
                items: GameStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.displayText)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _league,
                decoration: const InputDecoration(labelText: '聯賽名稱'),
                validator: (v) => (v == null || v.isEmpty) ? '必填欄位' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _away,
                decoration: const InputDecoration(labelText: '客隊'),
                validator: (v) => (v == null || v.isEmpty) ? '必填欄位' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _home,
                decoration: const InputDecoration(labelText: '主隊'),
                validator: (v) => (v == null || v.isEmpty) ? '必填欄位' : null,
              ),
              const SizedBox(height: 24),
              _label('比分明細'),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Expanded(flex: 2, child: Text('時段', style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
                  Expanded(child: Text('客隊', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
                  Expanded(child: Text('主隊', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 12))),
                ],
              ),
              const SizedBox(height: 4),
              ...List.generate(_scoreRows.length, (i) {
                final row = _scoreRows[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          row['label']!.text,
                          style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: row['away'],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: row['home'],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(widget.editGame == null ? '新增比賽' : '儲存更改'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final periods = _sport.defaultPeriods;
    final scorePeriods = <ScorePeriod>[];
    for (var i = 0; i < _scoreRows.length; i++) {
      final row = _scoreRows[i];
      final label = periods[i];
      scorePeriods.add(ScorePeriod(
        teamType: 'AWAY',
        periodLabel: label,
        score: int.tryParse(row['away']!.text) ?? 0,
        sortOrder: i,
      ));
      scorePeriods.add(ScorePeriod(
        teamType: 'HOME',
        periodLabel: label,
        score: int.tryParse(row['home']!.text) ?? 0,
        sortOrder: i,
      ));
    }

    final now = DateTime.now();
    final game = Game(
      id: widget.editGame?.id ?? _uuid.v4(),
      sportType: _sport,
      league: _league.text.trim(),
      homeTeam: _home.text.trim(),
      awayTeam: _away.text.trim(),
      status: _status,
      scorePeriods: scorePeriods,
      createdAt: widget.editGame?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.editGame == null) {
      await ref.read(gameProvider.notifier).add(game);
    } else {
      await ref.read(gameProvider.notifier).update(game);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.editGame == null ? '比賽已新增！' : '比賽已更新！'),
          backgroundColor: AppColors.greenDarkBadge,
        ),
      );
      Navigator.pop(context);
    }
  }
}
