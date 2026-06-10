import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/odds_calculator.dart';
import '../../bets/models/bet_slip.dart';
import '../../bets/models/bet_status.dart';
import '../../bets/providers/bet_provider.dart';
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

  // 投注類型（中文顯示，值保持英文供邏輯使用）
  final _betTypes = ['Spread', 'Moneyline', 'Total', 'Total Corners', 'Other'];
  final _betTypeLabels = ['讓分 Spread', '獨贏 Moneyline', '大小 Total', '角球 Total Corners', '其他 Other'];

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
    _wager = TextEditingController(text: b != null ? b.wagerAmount.toStringAsFixed(2) : '10.00');
    _placedAt = b?.placedAt ?? DateTime.now();
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
                items: games.map((g) => DropdownMenuItem(
                  value: g.id,
                  child: Text(
                    g.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                )).toList(),
                onChanged: (v) => setState(() => _selectedGameId = v),
                validator: (v) => (v == null) ? '請先選擇比賽' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _selection,
                decoration: const InputDecoration(labelText: '投注選項名稱'),
                validator: (v) => (v == null || v.isEmpty) ? '必填欄位' : null,
              ),
              const SizedBox(height: 16),
              _label('投注類型'),
              DropdownButtonFormField<String>(
                initialValue: _betTypes.contains(_betType.text) ? _betType.text : 'Other',
                dropdownColor: AppColors.innerCard,
                decoration: const InputDecoration(),
                items: List.generate(_betTypes.length, (i) => DropdownMenuItem(
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
                decoration: const InputDecoration(labelText: '賠率（例如 -110 或 +150）'),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.displayText)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 16),
              _label('投注時間'),
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
        child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      );

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
      _placedAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final games = ref.read(gameProvider);
    final game = games.firstWhere((g) => g.id == _selectedGameId!);
    final wager = double.parse(_wager.text);
    final odds = int.parse(_odds.text);
    final paid = calculatePaid(wager, odds, _status);

    final now = DateTime.now();
    final bet = BetSlip(
      id: widget.editBet?.id ?? _uuid.v4(),
      betCode: widget.editBet?.betCode ?? 'MK${now.millisecondsSinceEpoch}',
      gameId: _selectedGameId!,
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
