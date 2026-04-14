import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/extensions.dart';
import '../../data/json_loader.dart';
import '../../l10n/app_localizations.dart';
import '../../models/building_model.dart';
import '../../models/enums.dart';
import '../../providers/game_provider.dart';
import '../../providers/production_provider.dart'
    show productionServiceProvider, manualTrigger;

class ProductionTab extends ConsumerStatefulWidget {
  const ProductionTab({super.key});

  @override
  ConsumerState<ProductionTab> createState() => _ProductionTabState();
}

class _ProductionTabState extends ConsumerState<ProductionTab> {
  SectorType _selectedSector = SectorType.agriculture;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final l = AppLocalizations.of(context);

    final sectorBuildings = JsonLoader.buildings
        .where((d) => d.sector == _selectedSector.name)
        .toList();

    return Column(
      children: [
        _SectorChipRow(
          activeSectors: gameState.activeSectors,
          selected: _selectedSector,
          onSelect: (s) => setState(() => _selectedSector = s),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sectorBuildings.length,
            itemBuilder: (ctx, i) {
              final data = sectorBuildings[i];
              // Bu bina tipinden mevcut binalar
              final existing = gameState.buildings.values
                  .where((b) => b.type.name == data.type)
                  .toList();

              if (existing.isEmpty) {
                return _LockedBuildingCard(buildingData: data, l: l);
              }

              return Column(
                children: existing
                    .map((b) => _BuildingCard(building: b, buildingData: data))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Sektör chip row ---

class _SectorChipRow extends StatelessWidget {
  final List<SectorType> activeSectors;
  final SectorType selected;
  final ValueChanged<SectorType> onSelect;

  const _SectorChipRow({
    required this.activeSectors,
    required this.selected,
    required this.onSelect,
  });

  String _icon(SectorType s) => switch (s) {
        SectorType.agriculture => '🌾',
        SectorType.production  => '🏭',
        SectorType.logistics   => '🚛',
        SectorType.trade       => '🛒',
        SectorType.finance     => '💼',
        SectorType.technology  => '🔬',
      };

  String _label(BuildContext context, SectorType s) {
    final l = AppLocalizations.of(context);
    return switch (s) {
      SectorType.agriculture => l.sectorAgriculture,
      SectorType.production  => l.sectorProduction,
      SectorType.logistics   => l.sectorLogistics,
      SectorType.trade       => l.sectorTrade,
      SectorType.finance     => l.sectorFinance,
      SectorType.technology  => l.sectorTechnology,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: SectorType.values.map((s) {
          final isActive = activeSectors.contains(s);
          final isSelected = s == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${_icon(s)} ${_label(context, s)}'),
              selected: isSelected,
              onSelected: isActive ? (_) => onSelect(s) : null,
              backgroundColor: AppColors.bg,
              selectedColor: const Color(0xFF003D2E),
              labelStyle: TextStyle(
                color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              showCheckmark: false,
              avatar: isActive ? null : const Icon(Icons.lock, size: 14),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- Kilitli bina kartı ---

class _LockedBuildingCard extends StatelessWidget {
  final BuildingData buildingData;
  final AppLocalizations l;
  const _LockedBuildingCard({required this.buildingData, required this.l});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: 0.45,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  buildingData.nameKey,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
              Text(
                buildingData.baseCost.toGameFormat(),
                style: const TextStyle(color: AppColors.secondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Bina kartı ---

class _BuildingCard extends ConsumerStatefulWidget {
  final BuildingModel building;
  final BuildingData buildingData;
  const _BuildingCard({required this.building, required this.buildingData});

  @override
  ConsumerState<_BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends ConsumerState<_BuildingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  Color get _statusColor => switch (widget.building.status) {
        BuildingStatus.producing    => AppColors.success,
        BuildingStatus.waitingInput => AppColors.warning,
        BuildingStatus.storageFull  => AppColors.error,
        BuildingStatus.idle         => AppColors.textSecondary,
        BuildingStatus.noEnergy     => Colors.grey,
      };

  String _statusLabel(AppLocalizations l) =>
      switch (widget.building.status) {
        BuildingStatus.producing    => l.statusProducing,
        BuildingStatus.waitingInput => l.statusWaitingInput,
        BuildingStatus.storageFull  => l.statusStorageFull,
        BuildingStatus.idle         => l.statusIdle,
        BuildingStatus.noEnergy     => l.statusNoEnergy,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final b = widget.building;
    final data = widget.buildingData;
    final service = ref.read(productionServiceProvider);
    final progress = service.getProgress(b.id);
    final ratePerHour = service.getProductionRatePerHour(b);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık satırı
            Row(
              children: [
                Expanded(
                  child: Text(
                    _buildingName(b.type),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${l.level}${b.level}',
                  style: const TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Durum rozeti
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _statusLabel(l),
                  style: TextStyle(color: _statusColor, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  b.status == BuildingStatus.producing
                      ? AppColors.primary
                      : _statusColor.withValues(alpha: 0.5),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Hız + yönetici satırı
            Row(
              children: [
                Text(
                  '${ratePerHour.toStringAsFixed(1)} ${l.perHour}',
                  style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11),
                ),
                const Spacer(),
                _ManagerBadge(level: b.managerLevel),
              ],
            ),

            // Durum uyarı mesajı
            if (b.status == BuildingStatus.waitingInput ||
                b.status == BuildingStatus.storageFull)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  b.status == BuildingStatus.storageFull
                      ? l.storageFull
                      : l.statusWaitingInput,
                  style: TextStyle(color: _statusColor, fontSize: 11),
                ),
              ),

            const Divider(height: 16),

            // Aksiyon butonları
            Row(
              children: [
                // Manuel tetikle
                if (!b.hasManager)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => manualTrigger(ref, b.id),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Üret', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),

                const SizedBox(width: 8),

                // Yönetici ata
                OutlinedButton.icon(
                  onPressed: () => _showManagerSheet(context, b),
                  icon: const Icon(Icons.person_outline, size: 16),
                  label: Text(l.manager, style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 10),
                    side: const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),

                // Yükselt
                ElevatedButton.icon(
                  onPressed: () => _showUpgradeDialog(context, b, data),
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: Text(
                    b.upgradeCost(data.baseCost).toGameFormat(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(
    BuildContext context, BuildingModel b, BuildingData data) {
    final l = AppLocalizations.of(context);
    final cost = b.upgradeCost(data.baseCost);
    final nextTime = data.baseProductionTimeSec /
        (1 + b.level * data.levelBonus) /
        b.managerMultiplier;
    final currentTime = data.baseProductionTimeSec /
        (1 + (b.level - 1) * data.levelBonus) /
        b.managerMultiplier;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${_buildingName(b.type)} — ${l.level}${b.level} → ${b.level + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow('Süre', '${currentTime.toStringAsFixed(1)}sn → ${nextTime.toStringAsFixed(1)}sn'),
            _StatRow('Maliyet', cost.toGameFormat()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(gameProvider.notifier).upgradeBuilding(b.id);
            },
            child: Text(l.upgrade),
          ),
        ],
      ),
    );
  }

  void _showManagerSheet(BuildContext context, BuildingModel b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ManagerSheet(building: b),
    );
  }

  String _buildingName(BuildingType type) {
    final data = JsonLoader.getBuildingData(type.name);
    return data?.nameKey ?? type.name;
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary,
              fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ManagerBadge extends StatelessWidget {
  final ManagerLevel level;
  const _ManagerBadge({required this.level});

  Color get _color => switch (level) {
        ManagerLevel.none     => AppColors.textSecondary,
        ManagerLevel.intern   => AppColors.warning,
        ManagerLevel.expert   => AppColors.accent,
        ManagerLevel.manager  => Colors.purple,
        ManagerLevel.director => AppColors.error,
        ManagerLevel.ceo      => AppColors.secondary,
      };

  String _label(AppLocalizations l) => switch (level) {
        ManagerLevel.none     => l.managerNone,
        ManagerLevel.intern   => l.managerIntern,
        ManagerLevel.expert   => l.managerExpert,
        ManagerLevel.manager  => l.managerManager,
        ManagerLevel.director => l.managerDirector,
        ManagerLevel.ceo      => l.managerCEO,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: _color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _label(l),
        style: TextStyle(color: _color, fontSize: 10),
      ),
    );
  }
}

// --- Yönetici atama bottom sheet ---

class _ManagerSheet extends ConsumerWidget {
  final BuildingModel building;
  const _ManagerSheet({required this.building});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final gameState = ref.watch(gameProvider);
    final money = gameState.money;
    final diamonds = gameState.diamonds;

    final options = [
      (ManagerLevel.none,     0.0,    0,  '×1.0'),
      (ManagerLevel.intern,   500.0,  0,  '×1.0'),
      (ManagerLevel.expert,   2000.0, 0,  '×1.5'),
      (ManagerLevel.manager,  8000.0, 0,  '×2.0'),
      (ManagerLevel.director, 0.0,    50, '×3.0'),
      (ManagerLevel.ceo,      0.0,    200,'×5.0'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.assignManager,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...options.map((opt) {
              final (lvl, cost, diamond, mult) = opt;
              final isCurrent = building.managerLevel == lvl;
              final canAfford = diamond > 0
                  ? diamonds >= diamond
                  : money >= cost;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.bg,
                    border: Border.all(
                      color: isCurrent ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(mult, style: TextStyle(
                      fontSize: 10,
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
                title: Text(_levelName(l, lvl),
                    style: TextStyle(
                      color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    )),
                subtitle: cost > 0
                    ? Text(cost.toGameFormat(),
                        style: const TextStyle(fontSize: 11))
                    : diamond > 0
                        ? Text('$diamond 💎',
                            style: const TextStyle(fontSize: 11))
                        : null,
                trailing: isCurrent
                    ? const Icon(Icons.check_circle,
                        color: AppColors.primary, size: 18)
                    : null,
                enabled: !isCurrent && (lvl == ManagerLevel.none || canAfford),
                onTap: isCurrent
                    ? null
                    : () {
                        Navigator.pop(context);
                        if (lvl == ManagerLevel.none) {
                          ref.read(gameProvider.notifier)
                              .assignManager(building.id, lvl);
                        } else if (diamond > 0) {
                          if (ref.read(gameProvider.notifier)
                              .spendDiamonds(diamond)) {
                            ref.read(gameProvider.notifier)
                                .assignManager(building.id, lvl);
                          }
                        } else {
                          if (ref.read(gameProvider.notifier)
                              .spendMoney(cost)) {
                            ref.read(gameProvider.notifier)
                                .assignManager(building.id, lvl);
                          }
                        }
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _levelName(AppLocalizations l, ManagerLevel lvl) =>
      switch (lvl) {
        ManagerLevel.none     => l.managerNone,
        ManagerLevel.intern   => l.managerIntern,
        ManagerLevel.expert   => l.managerExpert,
        ManagerLevel.manager  => l.managerManager,
        ManagerLevel.director => l.managerDirector,
        ManagerLevel.ceo      => l.managerCEO,
      };
}
