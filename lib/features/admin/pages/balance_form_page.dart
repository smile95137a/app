import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../balance/providers/balance_provider.dart';

class BalanceFormPage extends ConsumerStatefulWidget {
  const BalanceFormPage({super.key});

  @override
  ConsumerState<BalanceFormPage> createState() => _BalanceFormPageState();
}

class _BalanceFormPageState extends ConsumerState<BalanceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final balance = ref.read(balanceProvider);
    _ctrl = TextEditingController(text: balance.balance.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('帳戶餘額設定')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ctrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: '餘額（美元）',
                  prefixText: '\$ ',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return '必填欄位';
                  if (double.tryParse(v) == null) return '請輸入有效數字';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('儲存餘額'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_ctrl.text);
    await ref.read(balanceProvider.notifier).update(amount);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('餘額已更新！'),
          backgroundColor: AppColors.greenDarkBadge,
        ),
      );
      Navigator.pop(context);
    }
  }
}
