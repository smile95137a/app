import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/odds_calculator.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
import '../../bets/models/parlay_leg.dart';
import '../../bets/providers/bet_provider.dart';
import '../../board/models/board_game.dart';
import '../../board/providers/board_provider.dart';
import '../../games/models/game.dart';
import '../../games/providers/game_provider.dart';

class BetFormPage extends ConsumerStatefulWidget {
  final BetSlip? editBet;
  const BetFormPage({super.key, this.editBet});

  @override
  ConsumerState<BetFormPage> createState() => _BetFormPageState();
}

class _BetFormPageState extends ConsumerState<BetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late BetStatus _status;
  String? _selectedGameId;
  late final TextEditingController _selection;
  late final TextEditingController _betType;
  late final TextEditingController _lineValue;
  late final TextEditingController _odds;
  late final TextEditingController _wager;
  late DateTime _placedAt;
  late bool _isParlay;
  final List<_BetOption> _parlayLegs = [];

  // 投注類型（中文顯示，值保持英文供邏輯使用）
  final _betTypes = ['Spread', 'Moneyline', 'Total', 'Total Corners', 'Other'];
  final _betTypeLabels = [
    '讓分 Spread',
    '獨贏 Moneyline',
    '大小 Total',
    '角球 Total Corners',
    '其他 Other'
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.editBet;
    _status = b?.resultStatus ?? BetStatus.open;
    _selectedGameId = b?.gameId;
    _selection = TextEditingController(text: b?.selectionName ?? '');
    _betType = TextEditingController(text: b?.betType ?? 'Moneyline');
    _lineValue = TextEditingController(text: b?.lineValue ?? '');
    _odds = TextEditingController(text: b != null ? '${b.odds}' : '-110');
    _wager = TextEditingController(
        text: b != null ? b.wagerAmount.toStringAsFixed(2) : '10.00');
    _placedAt = b?.placedAt ?? DateTime.now();
    _isParlay = b?.legs?.isNotEmpty ?? false;
    _parlayLegs.addAll(
      (b?.legs ?? const <ParlayLeg>[]).map(
        (leg) => _BetOption(
          label: '${leg.selectionDisplay} ${leg.oddsDisplay}',
          selectionName: leg.selectionName,
          betType: leg.betType,
          lineValue: leg.lineValue,
          odds: leg.odds,
          gameId: leg.gameId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selection.dispose();
    _betType.dispose();
    _lineValue.dispose();
    _odds.dispose();
    _wager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gameProvider);
    final boardGames =
        ref.watch(boardProvider).valueOrNull ?? const <BoardGame>[];
    final selectedGame = _selectedGameId == null
        ? null
        : _firstWhereOrNull(games, (g) => g.id == _selectedGameId);
    final boardGame =
        selectedGame == null ? null : _findBoardGame(selectedGame, boardGames);
    final betOptions =
        boardGame == null ? const <_BetOption>[] : _buildBetOptions(boardGame);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editBet == null ? '新增投注' : '編輯投注'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('選擇比賽'),
              DropdownButtonFormField<String>(
                initialValue: _selectedGameId,
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(hintText: '請選擇比賽'),
                items: games
                    .map((g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(
                            g.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedGameId = v;
                  final game = _firstWhereOrNull(games, (g) => g.id == v);
                  final board =
                      game == null ? null : _findBoardGame(game, boardGames);
                  if (!_isParlay && board != null) {
                    _applyBetOption(_buildBetOptions(board).first);
                  } else if (!_isParlay &&
                      game != null &&
                      _selection.text.trim().isEmpty) {
                    _selection.text = game.awayTeam;
                    _betType.text = 'Moneyline';
                    _lineValue.clear();
                  }
                }),
                validator: (v) => (v == null) ? '請先選擇比賽' : null,
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.innerCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isParlay ? '串關模式' : '單注模式',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isParlay,
                      activeThumbColor: AppColors.green,
                      activeTrackColor: AppColors.greenDarkBadge,
                      onChanged: (value) => setState(() {
                        _isParlay = value;
                        if (_isParlay) {
                          _syncParlayFields();
                        } else if (betOptions.isNotEmpty) {
                          _applyBetOption(betOptions.first);
                        }
                      }),
                    ),
                  ],
                ),
              ),
              if (betOptions.isNotEmpty) ...[
                const SizedBox(height: 12),
                _label('快速帶入投注選項'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: betOptions
                      .map(
                        (option) => OutlinedButton(
                          onPressed: () => setState(() {
                            if (_isParlay) {
                              _addParlayLeg(option);
                            } else {
                              _applyBetOption(option);
                            }
                          }),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.divider),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            option.label,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (_isParlay) ...[
                const SizedBox(height: 16),
                _label('Parlay legs (${_parlayLegs.length})'),
                if (_parlayLegs.isEmpty)
                  const Text(
                    'Select a game, then tap an odds option to add a leg.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  )
                else
                  Column(
                    children: List.generate(_parlayLegs.length, (index) {
                      final leg = _parlayLegs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.innerCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${leg.selectionDisplay} ${leg.oddsDisplay}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    leg.betType,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _parlayLegs.removeAt(index);
                                _syncParlayFields();
                              }),
                              icon: const Icon(Icons.close),
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _selection,
                decoration: const InputDecoration(labelText: '投注選項名稱'),
                validator: (v) => (v == null || v.isEmpty) ? '必填欄位' : null,
              ),
              const SizedBox(height: 16),
              _label('投注類型'),
              DropdownButtonFormField<String>(
                initialValue:
                    _betTypes.contains(_betType.text) ? _betType.text : 'Other',
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(),
                items: List.generate(
                    _betTypes.length,
                    (i) => DropdownMenuItem(
                          value: _betTypes[i],
                          child: Text(_betTypeLabels[i]),
                        )),
                onChanged: (v) => setState(() => _betType.text = v ?? 'Other'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lineValue,
                decoration: const InputDecoration(labelText: '讓分值（例如 -2.5，選填）'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _odds,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: '賠率（例如 -110 或 +150）'),
                validator: (v) {
                  if (v == null || v.isEmpty) return '必填欄位';
                  final n = int.tryParse(v);
                  if (n == null) return '請輸入有效整數';
                  if (n == 0) return '賠率不可為 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _wager,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: '投注金額（\$）'),
                validator: (v) {
                  if (v == null || v.isEmpty) return '必填欄位';
                  final n = double.tryParse(v);
                  if (n == null) return '請輸入有效數字';
                  if (n <= 0) return '金額必須大於 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _label('結果狀態'),
              DropdownButtonFormField<BetStatus>(
                initialValue: _status,
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(),
                items: BetStatus.values
                    .map((s) =>
                        DropdownMenuItem(value: s, child: Text(s.displayText)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 16),
              _label('投注時間'),
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.innerCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    _placedAt.toString().substring(0, 19),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(widget.editBet == null ? '新增投注' : '儲存更改'),
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
        child: Text(text,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      );

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  BoardGame? _findBoardGame(Game game, List<BoardGame> boardGames) {
    final home = _normalizeTeam(game.homeTeam);
    final away = _normalizeTeam(game.awayTeam);
    for (final boardGame in boardGames) {
      final sameId = boardGame.id == game.id;
      final sameTeams = _normalizeTeam(boardGame.homeTeam) == home &&
          _normalizeTeam(boardGame.awayTeam) == away;
      final sameSport = boardGame.sport == game.sportType;
      if (sameId || (sameTeams && sameSport)) return boardGame;
    }
    return null;
  }

  String _normalizeTeam(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  List<_BetOption> _buildBetOptions(BoardGame game) {
    final total = _fmtTotal(game.total);
    return [
      _BetOption(
        label: '${game.awayTeam} ML ${BoardGame.fmtOdds(game.awayMoneyline)}',
        selectionName: game.awayTeam,
        betType: 'Moneyline',
        odds: game.awayMoneyline,
        gameId: game.id,
      ),
      _BetOption(
        label: '${game.homeTeam} ML ${BoardGame.fmtOdds(game.homeMoneyline)}',
        selectionName: game.homeTeam,
        betType: 'Moneyline',
        odds: game.homeMoneyline,
        gameId: game.id,
      ),
      _BetOption(
        label:
            '${game.awayTeam} ${BoardGame.fmtSpread(game.awaySpread)} ${BoardGame.fmtOdds(game.awaySpreadOdds)}',
        selectionName: game.awayTeam,
        betType: 'Spread',
        lineValue: BoardGame.fmtSpread(game.awaySpread),
        odds: game.awaySpreadOdds,
        gameId: game.id,
      ),
      _BetOption(
        label:
            '${game.homeTeam} ${BoardGame.fmtSpread(game.homeSpread)} ${BoardGame.fmtOdds(game.homeSpreadOdds)}',
        selectionName: game.homeTeam,
        betType: 'Spread',
        lineValue: BoardGame.fmtSpread(game.homeSpread),
        odds: game.homeSpreadOdds,
        gameId: game.id,
      ),
      _BetOption(
        label: 'Over $total ${BoardGame.fmtOdds(game.overOdds)}',
        selectionName: 'Over',
        betType: 'Total',
        lineValue: total,
        odds: game.overOdds,
        gameId: game.id,
      ),
      _BetOption(
        label: 'Under $total ${BoardGame.fmtOdds(game.underOdds)}',
        selectionName: 'Under',
        betType: 'Total',
        lineValue: total,
        odds: game.underOdds,
        gameId: game.id,
      ),
    ];
  }

  String _fmtTotal(double total) => total == total.roundToDouble()
      ? total.toStringAsFixed(0)
      : total.toString();

  void _applyBetOption(_BetOption option) {
    _selection.text = option.selectionName;
    _betType.text = option.betType;
    _lineValue.text = option.lineValue ?? '';
    _odds.text = option.odds.toString();
  }

  void _addParlayLeg(_BetOption option) {
    if (option.gameId == null) return;
    _parlayLegs.add(option);
    _syncParlayFields();
  }

  void _syncParlayFields() {
    if (!_isParlay) return;
    _selection.text =
        _parlayLegs.isEmpty ? '' : '${_parlayLegs.length} Pick Parlay';
    _betType.text = _parlayLegs.map((leg) => leg.selectionDisplay).join(', ');
    _lineValue.clear();
    if (_parlayLegs.isNotEmpty) {
      _odds.text = _calculateParlayOdds(_parlayLegs).toString();
    }
  }

  int _calculateParlayOdds(List<_BetOption> legs) {
    var decimalOdds = 1.0;
    for (final leg in legs) {
      decimalOdds *= _americanToDecimal(leg.odds);
    }
    return _decimalToAmerican(decimalOdds);
  }

  double _americanToDecimal(int odds) =>
      odds > 0 ? 1 + odds / 100 : 1 + 100 / odds.abs();

  int _decimalToAmerican(double decimalOdds) {
    if (decimalOdds >= 2) {
      return ((decimalOdds - 1) * 100).round();
    }
    return (-100 / (decimalOdds - 1)).round();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _placedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_placedAt),
    );
    if (time == null) return;
    setState(() {
      _placedAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isParlay && _parlayLegs.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parlay needs at least 2 legs.')),
      );
      return;
    }

    final games = ref.read(gameProvider);
    final gameIdForBet =
        _isParlay ? _parlayLegs.first.gameId! : _selectedGameId!;
    final game = games.firstWhere((g) => g.id == gameIdForBet);
    final wager = double.parse(_wager.text);
    final odds = int.parse(_odds.text);
    final paid = calculatePaid(wager, odds, _status);
    final legs = _isParlay
        ? _parlayLegs
            .map(
              (leg) => ParlayLeg(
                selectionName: leg.selectionName,
                lineValue: leg.lineValue,
                odds: leg.odds,
                betType: leg.betType,
                gameId: leg.gameId!,
                won: _status == BetStatus.won,
              ),
            )
            .toList()
        : null;

    final now = DateTime.now();
    final bet = BetSlip(
      id: widget.editBet?.id ?? _uuid.v4(),
      betCode: widget.editBet?.betCode ?? 'MK${now.millisecondsSinceEpoch}',
      gameId: gameIdForBet,
      sportType: game.sportType,
      selectionName: _selection.text.trim(),
      betType: _betType.text.trim(),
      lineValue: _lineValue.text.trim().isEmpty ? null : _lineValue.text.trim(),
      odds: odds,
      wagerAmount: wager,
      paidAmount: paid,
      resultStatus: _status,
      placedAt: _placedAt,
      settledAt: _status != BetStatus.open ? now : null,
      createdAt: widget.editBet?.createdAt ?? now,
      updatedAt: now,
      legs: legs,
    );

    if (widget.editBet == null) {
      await ref.read(betProvider.notifier).add(bet);
    } else {
      await ref.read(betProvider.notifier).update(bet);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.editBet == null ? '投注已新增！' : '投注已更新！'),
          backgroundColor: AppColors.greenDarkBadge,
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _BetOption {
  final String label;
  final String selectionName;
  final String betType;
  final String? lineValue;
  final int odds;
  final String? gameId;

  const _BetOption({
    required this.label,
    required this.selectionName,
    required this.betType,
    required this.odds,
    this.lineValue,
    this.gameId,
  });

  String get oddsDisplay => odds > 0 ? '+$odds' : '$odds';

  String get selectionDisplay => lineValue != null && lineValue!.isNotEmpty
      ? '$selectionName $lineValue'
      : selectionName;
}
