import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';
import '../core/extensions.dart';
import '../providers/game_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/production_provider.dart';
import '../services/save_service.dart';
import 'tabs/production_tab.dart';
import 'tabs/inventory_tab.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Timer? _autoSaveTimer;
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Game loop — her frame çalışır
    _ticker = createTicker((elapsed) {
      final deltaTime = elapsed == Duration.zero
          ? 0.0
          : (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
      _lastElapsed = elapsed;
      if (deltaTime > 0 && deltaTime < 1.0) {
        productionTick(ref, deltaTime);
      }
    });
    _ticker.start();

    // Auto-save
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: AppConstants.autoSaveIntervalSeconds),
      (_) => _autoSave(),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  Future<void> _autoSave() async {
    final state = ref.read(gameProvider);
    final inventory = ref.read(inventoryProvider);
    await SaveService.saveAll(state, inventory);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final tabs = [
      l.tabProduction,
      l.tabInventory,
      l.tabTransport,
      l.tabContracts,
      l.tabResearch,
    ];

    final icons = [
      Icons.factory_outlined,
      Icons.inventory_2_outlined,
      Icons.local_shipping_outlined,
      Icons.assignment_outlined,
      Icons.science_outlined,
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: switch (_selectedIndex) {
                0 => const ProductionTab(),
                1 => const InventoryTab(),
                _ => _PlaceholderTab(label: tabs[_selectedIndex]),
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _GameMenuButton(onSave: _autoSave),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: List.generate(
          5,
          (i) => NavigationDestination(icon: Icon(icons[i]), label: tabs[i]),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final l = AppLocalizations.of(context);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _StatChip(icon: '💰', value: state.money.toGameFormat()),
          const SizedBox(width: 8),
          _StatChip(icon: '💎', value: '${state.diamonds}'),
          const SizedBox(width: 8),
          _StatChip(icon: '🏆', value: '${state.prestigePoints}'),
          const Spacer(),
          Text(
            '0${l.perHour}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String value;
  const _StatChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameMenuButton extends StatelessWidget {
  final Future<void> Function() onSave;
  const _GameMenuButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FloatingActionButton(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textSecondary,
      mini: true,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.save_outlined, color: AppColors.primary),
                    title: Text(l.save),
                    onTap: () async {
                      Navigator.pop(ctx);
                      await onSave();
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kaydedildi'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined,
                        color: AppColors.textSecondary),
                    title: Text(l.settings),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_outlined,
                        color: AppColors.textSecondary),
                    title: const Text('Ana Menü'),
                    onTap: () async {
                      Navigator.pop(ctx);
                      await onSave();
                      if (context.mounted) context.go('/');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: const Icon(Icons.menu),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.comingSoon,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
