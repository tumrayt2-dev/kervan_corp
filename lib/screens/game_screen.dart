import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';
import '../core/extensions.dart';
import '../providers/game_provider.dart';
import '../providers/inventory_provider.dart';
import '../services/save_service.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int _selectedIndex = 0;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: AppConstants.autoSaveIntervalSeconds),
      (_) => _autoSave(),
    );
  }

  @override
  void dispose() {
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
              child: _PlaceholderTab(label: tabs[_selectedIndex]),
            ),
          ],
        ),
      ),
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
