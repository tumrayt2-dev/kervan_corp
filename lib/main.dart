import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/json_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('player');
  await Hive.openBox('inventory');
  await JsonLoader.loadAll();
  runApp(
    const ProviderScope(
      child: KervanApp(),
    ),
  );
}
