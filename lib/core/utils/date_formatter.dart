import 'package:intl/intl.dart';

final _fmt = DateFormat('MMM d, yyyy, h:mm:ss a', 'en_US');

String formatPlacedTime(DateTime dt) => _fmt.format(dt);
