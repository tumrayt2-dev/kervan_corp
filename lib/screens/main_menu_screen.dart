import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  bool _hasSave() {
    final box = Hive.box('player');
    return box.isNotEmpty;
  }

  Future<void> _startNewGame(BuildContext context) async {
    final box = Hive.box('player');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        return AlertDialog(
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
        );
      },
    );
    if (confirmed == true) {
      await box.clear();
      if (context.mounted) context.go('/game');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hasSave = _hasSave();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // Logo / Başlık
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
              // Butonlar
              if (hasSave) ...[
                ElevatedButton(
                  onPressed: () => context.go('/game'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l.continueGame, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _startNewGame(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Text(l.newGame,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () => context.go('/game'),
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
              // Versiyon
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
