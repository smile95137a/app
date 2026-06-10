import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'storage/hive_boxes.dart';
import 'storage/seed_data.dart';
import 'features/bets/repositories/bet_repository.dart';
import 'features/games/repositories/game_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.bets);
  await Hive.openBox(HiveBoxes.games);
  await Hive.openBox(HiveBoxes.balance);
  await Hive.openBox(HiveBoxes.meta);

  await _seedIfNeeded();

  runApp(const ProviderScope(child: MockKingsApp()));
}

Future<void> _seedIfNeeded() async {
  final meta = Hive.box(HiveBoxes.meta);
  const seedVersion = 5;
  if (meta.get('seedVersion') == seedVersion) return;

  final gameRepo = GameRepository();
  final betRepo = BetRepository();

  await gameRepo.clearAll();
  await betRepo.clearAll();

  for (final g in SeedData.games) {
    await gameRepo.createGame(g);
  }
  for (final b in SeedData.bets) {
    await betRepo.createBet(b);
  }

  await meta.put('seeded', true);
  await meta.put('seedVersion', seedVersion);
}
