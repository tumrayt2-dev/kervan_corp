import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';
import '../services/save_service.dart';
import '../providers/game_provider.dart';
import '../providers/inventory_provider.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    _hasSave = SaveService.hasSave;
  }

  Future<void> _continueGame() async {
    final loaded = SaveService.loadGame();
    if (loaded != null) {
      ref.read(gameProvider.notifier).loadState(loaded.$1);
      ref.read(inventoryProvider.notifier).loadInventory(loaded.$2);
    }
    if (mounted) context.go('/game');
  }

  Future<void> _startNewGame() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.newGameConfirmTitle),
        content: Text(l.newGameConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await SaveService.deleteSave();
      final newState = SaveService.createNewGame();
      final newInventory = SaveService.createNewInventory();
      await SaveService.saveAll(newState, newInventory);
      ref.read(gameProvider.notifier).loadState(newState);
      ref.read(inventoryProvider.notifier).loadInventory(newInventory);
      if (mounted) context.go('/game');
    }
  }

  Future<void> _playNew() async {
    final newState = SaveService.createNewGame();
    final newInventory = SaveService.createNewInventory();
    await SaveService.saveAll(newState, newInventory);
    ref.read(gameProvider.notifier).loadState(newState);
    ref.read(inventoryProvider.notifier).loadInventory(newInventory);
    if (mounted) context.go('/game');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                l.appTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Idle Business Tycoon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              if (_hasSave) ...[
                ElevatedButton(
                  onPressed: _continueGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l.continueGame, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _startNewGame,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Text(l.newGame,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _playNew,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l.play, style: const TextStyle(fontSize: 16)),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/settings'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Text(l.settings,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              ),
              const Spacer(),
              Text(
                '${l.version} 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
