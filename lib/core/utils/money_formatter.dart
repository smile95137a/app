import 'package:intl/intl.dart';

final _fmt = NumberFormat('#,##0.00', 'en_US');

String formatMoney(double amount) => '\$${_fmt.format(amount)}';
