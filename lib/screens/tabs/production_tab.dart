import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/extensions.dart';
import '../../core/localization_helpers.dart';
import '../../data/json_loader.dart';
import '../../l10n/app_localizations.dart';
import '../../models/building_model.dart';
import '../../models/enums.dart';
import '../../providers/game_provider.dart';
import '../../providers/production_provider.dart'
    show productionServiceProvider, manualTrigger;

// ─── Bina tipi renk + emoji yardımcıları ─────────────────────────────────────

Color _typeColor(String t) => switch (t) {
      'farm'             => const Color(0xFF66BB6A),
      'mine'             => const Color(0xFF78909C),
      'forest'           => const Color(0xFF43A047),
      'ranch'            => const Color(0xFFFF8A65),
      'quarry'           => const Color(0xFFBCAAA4),
      'mill'             => const Color(0xFFF9A825),
      'ironFactory'      => const Color(0xFF546E7A),
      'woodProcessing'   => const Color(0xFF8D6E63),
      'dairyFactory'     => const Color(0xFF4DD0E1),
      'textileFactory'   => const Color(0xFFCE93D8),
      'bakery'           => const Color(0xFFFFCA28),
      'steelFactory'     => const Color(0xFF607D8B),
      'furnitureFactory' => const Color(0xFFA1887F),
      'clothingFactory'  => const Color(0xFFF48FB1),
      'readyFoodFactory' => const Color(0xFFFF7043),
      'machineFactory'   => const Color(0xFF42A5F5),
      _                  => AppColors.primary,
    };

String _typeEmoji(String t) => switch (t) {
      'farm'             => '🌾',
      'mine'             => '⛏️',
      'forest'           => '🌲',
      'ranch'            => '🐄',
      'quarry'           => '🪨',
      'mill'             => '⚙️',
      'ironFactory'      => '🔩',
      'woodProcessing'   => '🪵',
      'dairyFactory'     => '🥛',
      'textileFactory'   => '🧵',
      'bakery'           => '🍞',
      'steelFactory'     => '🔧',
      'furnitureFactory' => '🪑',
      'clothingFactory'  => '👗',
      'readyFoodFactory' => '🍔',
      'machineFactory'   => '🤖',
      _                  => '🏭',
    };

// ─── Ana sekme ─────────────────────────────────────────────────────────────

class ProductionTab extends ConsumerStatefulWidget {
  const ProductionTab({super.key});

  @override
  ConsumerState<ProductionTab> createState() => _ProductionTabState();
}

class _ProductionTabState extends ConsumerState<ProductionTab> {
  SectorType _selectedSector = SectorType.agriculture;

  /// Seçili sektördeki sahip olunan binaları tipe göre grupla
  Map<String, List<BuildingModel>> _grouped(Map<String, BuildingModel> buildings) {
    final sectorTypes = JsonLoader.buildings
        .where((d) => d.sector == _selectedSector.name)
        .map((d) => d.type)
        .toSet();

    final result = <String, List<BuildingModel>>{};
    for (final b in buildings.values) {
      if (sectorTypes.contains(b.type.name)) {
        result.putIfAbsent(b.type.name, () => []).add(b);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final gameState = ref.watch(gameProvider);
    final grouped = _grouped(gameState.buildings);
    final sectorTypes = JsonLoader.buildings
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              // ─── Yeni Tesis Ekle ───
              _AddBuildingButton(
                onTap: () => _showBuildingPicker(context, sectorTypes, l),
              ),
              const SizedBox(height: 14),

              // ─── Boş durum ───
              if (grouped.isEmpty) const _EmptyState(),

              // ─── Accordion bölümleri ───
              ...sectorTypes
                  .where((d) => grouped.containsKey(d.type))
                  .map((data) => _BuildingTypeSection(
                        buildingData: data,
                        ownedBuildings: grouped[data.type]!,
                        l: l,
                      )),
            ],
          ),
        ),
      ],
    );
  }

  void _showBuildingPicker(
    BuildContext context,
    List<BuildingData> types,
    AppLocalizations l,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _BuildingTypePickerSheet(
        buildingTypes: types,
        l: l,
        onNeedsRecipePicker: (id, data, recipes) {
          if (!context.mounted) return;
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.surface,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => _RecipePickerSheet(
              buildingId: id,
              buildingData: data,
              recipes: recipes,
              l: l,
            ),
          );
        },
      ),
    );
  }
}

// ─── Sektör tab row ────────────────────────────────────────────────────────

class _SectorChipRow extends StatelessWidget {
  final List<SectorType> activeSectors;
  final SectorType selected;
  final ValueChanged<SectorType> onSelect;

  const _SectorChipRow({
    required this.activeSectors,
    required this.selected,
    required this.onSelect,
  });

  static const _icons = {
    SectorType.agriculture: '⛏️',
    SectorType.production : '🏭',
    SectorType.logistics  : '🚛',
    SectorType.trade      : '🛒',
    SectorType.finance    : '💼',
    SectorType.technology : '🔬',
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
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        children: SectorType.values.map((s) {
          final isActive = activeSectors.contains(s);
          final isSelected = s == selected;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: isActive ? () => onSelect(s) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isActive ? AppColors.bg : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isActive ? AppColors.border
                            : AppColors.border.withValues(alpha: 0.4),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isActive)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.lock, size: 12,
                            color: AppColors.textSecondary),
                      ),
                    Text(
                      '${_icons[s]} ${_label(context, s)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : isActive ? AppColors.textPrimary
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Yeni tesis ekle butonu ────────────────────────────────────────────────

class _AddBuildingButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBuildingButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.18),
              AppColors.accent.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.55),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yeni Tesis Ekle',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tesis seç ve üretime başla',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ─── Boş durum ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Text('🏗️', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          const Text(
            'Henüz tesis yok',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Yukarıdan yeni bir tesis ekleyerek\nüretime başla!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Tesis tipi seçim sheet'i ─────────────────────────────────────────────

class _BuildingTypePickerSheet extends ConsumerWidget {
  final List<BuildingData> buildingTypes;
  final AppLocalizations l;
  final void Function(
    String buildingId,
    BuildingData data,
    List<ProductionRecipe> recipes,
  ) onNeedsRecipePicker;

  const _BuildingTypePickerSheet({
    required this.buildingTypes,
    required this.l,
    required this.onNeedsRecipePicker,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Tesis Seç',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${gameState.money.toGameFormat()} mevcut',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              children: buildingTypes.map((data) {
                final owned = gameState.buildings.values
                    .where((b) => b.type.name == data.type)
                    .length;
                final cost = ref.read(gameProvider.notifier)
                    .purchaseCostFor(data.type);
                final canAfford = gameState.money >= cost;
                final color = _typeColor(data.type);
                final emoji = _typeEmoji(data.type);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withValues(alpha: 0.25),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sol renk bar
                        Container(
                          width: 4,
                          color: color,
                        ),
                        // İçerik
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                // Emoji badge
                                Container(
                                  width: 46, height: 46,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: color.withValues(alpha: 0.4)),
                                  ),
                                  child: Center(
                                    child: Text(emoji,
                                        style: const TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        buildingName(l, data.type),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (owned > 0)
                                        Text(
                                          '$owned aktif',
                                          style: TextStyle(
                                              color: color, fontSize: 11),
                                        )
                                      else
                                        const Text(
                                          'Henüz yok',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Satın alma butonu — her zaman yeşil
                                ElevatedButton.icon(
                                  onPressed: canAfford
                                      ? () => _buy(context, ref, data)
                                      : null,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: Text(
                                    cost.toGameFormat(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canAfford
                                        ? AppColors.success
                                        : AppColors.border,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    minimumSize: const Size(0, 44),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _buy(BuildContext context, WidgetRef ref, BuildingData data) {
    final recipes = JsonLoader.getRecipesForBuilding(data.type);
    final id = ref.read(gameProvider.notifier).purchaseBuilding(data.type);
    if (id == null) return;

    if (recipes.length <= 1) {
      if (recipes.isNotEmpty) {
        ref.read(gameProvider.notifier).assignRecipe(id, recipes.first.recipeId);
      }
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      onNeedsRecipePicker(id, data, recipes);
    }
  }
}

// ─── Accordion bölümü (tipe göre) ─────────────────────────────────────────

class _BuildingTypeSection extends StatelessWidget {
  final BuildingData buildingData;
  final List<BuildingModel> ownedBuildings;
  final AppLocalizations l;

  const _BuildingTypeSection({
    required this.buildingData,
    required this.ownedBuildings,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(buildingData.type);
    final emoji = _typeEmoji(buildingData.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Theme(
        // Divider'ı gizle
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(8, 0, 8, 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          leading: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: color.withValues(alpha: 0.5), width: 1),
            ),
            child:
                Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          title: Text(
            buildingName(l, buildingData.type),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${ownedBuildings.length} tesis aktif',
            style: TextStyle(color: color, fontSize: 11),
          ),
          iconColor: color,
          collapsedIconColor: AppColors.textSecondary,
          children: ownedBuildings
              .map((b) => _BuildingCard(
                    building: b,
                    buildingData: buildingData,
                    accentColor: color,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ─── Tarif seçim sheet ─────────────────────────────────────────────────────

class _RecipePickerSheet extends ConsumerWidget {
  final String buildingId;
  final BuildingData buildingData;
  final List<ProductionRecipe> recipes;
  final AppLocalizations l;
  final bool isChange;
  final String? currentRecipeId;

  const _RecipePickerSheet({
    required this.buildingId,
    required this.buildingData,
    required this.recipes,
    required this.l,
    this.isChange = false,
    this.currentRecipeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final money = ref.watch(gameProvider).money;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              buildingName(l, buildingData.type),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isChange ? 'Üretimi değiştir:' : 'Ne üretmek istiyorsun?',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...recipes.map((r) {
              final isCurrent = r.recipeId == currentRecipeId;
              final cost = ref
                  .read(gameProvider.notifier)
                  .recipeCostFor(r.recipeId);
              final canAfford = cost <= 0 || money >= cost;
              final outputType =
                  r.outputs.isNotEmpty ? r.outputs.first.productType : null;
              final emoji =
                  outputType != null ? productEmoji(outputType) : '📦';
              final name = outputType != null
                  ? productName(l, outputType)
                  : r.recipeId;

              void doAssign() {
                ref
                    .read(gameProvider.notifier)
                    .assignRecipe(buildingId, r.recipeId);
                ref
                    .read(productionServiceProvider)
                    .timers
                    .remove(buildingId);
                Navigator.pop(context);
              }

              return Opacity(
                opacity: isCurrent ? 0.5 : 1.0,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.bg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    '${r.processingTimeSec.toStringAsFixed(0)}sn / tur  •  '
                    '+${r.outputs.map((o) => o.quantity.toStringAsFixed(0)).join('/')} adet',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: isCurrent
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: AppColors.primary),
                          ),
                          child: const Text('Mevcut',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary)),
                        )
                      : cost > 0
                          ? ElevatedButton(
                              onPressed: canAfford ? doAssign : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                backgroundColor: canAfford
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                              child: Text(cost.toGameFormat(),
                                  style:
                                      const TextStyle(fontSize: 11)),
                            )
                          : TextButton(
                              onPressed: doAssign,
                              child: const Text('Seç'),
                            ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Bina kartı ────────────────────────────────────────────────────────────

class _BuildingCard extends ConsumerStatefulWidget {
  final BuildingModel building;
  final BuildingData buildingData;
  final Color accentColor;

  const _BuildingCard({
    required this.building,
    required this.buildingData,
    required this.accentColor,
  });

  @override
  ConsumerState<_BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends ConsumerState<_BuildingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  int _lastCompletedCycles = -1;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(_onFrame)
      ..repeat();
  }

  void _onFrame() {
    final service = ref.read(productionServiceProvider);
    final timer = service.timers[widget.building.id];
    if (timer != null && timer.completedCycles != _lastCompletedCycles) {
      _lastCompletedCycles = timer.completedCycles;
    }
    setState(() {});
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

  /// Seçili tarife göre dinamik bina adı (tarım sektörü)
  String _cardTitle(AppLocalizations l, BuildingModel b) {
    if (b.selectedRecipeId == null) return buildingName(l, b.type.name);

    final recipe = JsonLoader.recipes
        .where((r) => r.recipeId == b.selectedRecipeId)
        .firstOrNull;
    if (recipe == null || recipe.outputs.isEmpty) {
      return buildingName(l, b.type.name);
    }

    final out = recipe.outputs.first.productType;
    final emoji = productEmoji(out);
    final pName = productName(l, out);

    return switch (b.type) {
      BuildingType.farm   => '$emoji $pName Tarlası',
      BuildingType.ranch  => '$emoji $pName Çiftliği',
      BuildingType.quarry => '$emoji $pName Ocağı',
      BuildingType.mine   => '$emoji $pName Madeni',
      _                   => buildingName(l, b.type.name),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final b = widget.building;
    final data = widget.buildingData;
    final service = ref.read(productionServiceProvider);
    final progress = service.getProgress(b.id);
    final recipes = JsonLoader.getRecipesForBuilding(b.type.name);
    final activeRecipe = service.getFirstRecipe(b);
    final isMultiRecipe = recipes.length > 1;
    final accent = widget.accentColor;

    // Tarif seçilmemiş → uyarı
    if (b.selectedRecipeId == null && isMultiRecipe) {
      return _NoRecipeCard(building: b, buildingData: data, l: l);
    }

    final cycleText = activeRecipe != null
        ? activeRecipe.outputs
            .map((o) =>
                '${productEmoji(o.productType)} +${o.quantity.toStringAsFixed(0)} ${productName(l, o.productType)}')
            .join('  ')
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sol renk bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            // İçerik
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık satırı
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _cardTitle(l, b),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${l.level}${b.level}',
                            style: TextStyle(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Durum
                    Row(
                      children: [
                        Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _statusLabel(l),
                          style: TextStyle(
                              color: _statusColor, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            accent.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          b.status == BuildingStatus.producing
                              ? accent
                              : _statusColor.withValues(alpha: 0.4),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Tur bilgisi + yönetici rozeti
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cycleText.isEmpty ? '' : '$cycleText / Tur',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11),
                          ),
                        ),
                        _ManagerBadge(level: b.managerLevel),
                      ],
                    ),

                    // Hata mesajı
                    if (b.status == BuildingStatus.waitingInput ||
                        b.status == BuildingStatus.storageFull)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          b.status == BuildingStatus.storageFull
                              ? l.storageFull
                              : l.statusWaitingInput,
                          style: TextStyle(
                              color: _statusColor, fontSize: 10),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Divider(
                          height: 1,
                          color: accent.withValues(alpha: 0.2)),
                    ),

                    const SizedBox(height: 8),

                    // Aksiyon — 2 satır
                    Column(
                      children: [
                        // Satır 1: üret + değiştir
                        if (!b.hasManager || isMultiRecipe)
                          Row(
                            children: [
                              if (!b.hasManager)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed:
                                        b.status ==
                                                BuildingStatus.producing
                                            ? null
                                            : () => _onManualProduce(
                                                context, b, l),
                                    icon: const Icon(
                                        Icons.play_arrow,
                                        size: 15),
                                    label: Text(l.produce,
                                        style: const TextStyle(
                                            fontSize: 12)),
                                    style: OutlinedButton.styleFrom(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                      side: BorderSide(
                                        color: b.status ==
                                                BuildingStatus.producing
                                            ? AppColors.border
                                            : accent,
                                      ),
                                      foregroundColor: accent,
                                    ),
                                  ),
                                ),
                              if (!b.hasManager && isMultiRecipe)
                                const SizedBox(width: 6),
                              if (isMultiRecipe)
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _showChangeRecipeSheet(
                                          context, b, recipes, l),
                                  icon: const Icon(Icons.swap_horiz,
                                      size: 15),
                                  label: const Text('Değiştir',
                                      style:
                                          TextStyle(fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10),
                                    side: const BorderSide(
                                        color: AppColors.border),
                                    foregroundColor:
                                        AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        if (!b.hasManager || isMultiRecipe)
                          const SizedBox(height: 6),

                        // Satır 2: yönetici + yükselt
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _showManagerSheet(context, b),
                                icon: const Icon(
                                    Icons.person_outline,
                                    size: 15),
                                label: Text(l.manager,
                                    style: const TextStyle(
                                        fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 5),
                                  side: const BorderSide(
                                      color: AppColors.border),
                                  foregroundColor:
                                      AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showUpgradeDialog(context, b, data),
                              icon: const Icon(Icons.arrow_upward,
                                  size: 15),
                              label: Text(
                                b.upgradeCost(data.baseCost)
                                    .toGameFormat(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onManualProduce(
      BuildContext context, BuildingModel b, AppLocalizations l) {
    final result = manualTrigger(ref, b.id);
    if (result == BuildingStatus.storageFull) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text(l.storageFull),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ));
    } else if (result == BuildingStatus.waitingInput) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text(l.statusWaitingInput),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.warning,
        ));
    }
  }

  void _showChangeRecipeSheet(
    BuildContext context,
    BuildingModel b,
    List<ProductionRecipe> recipes,
    AppLocalizations l,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _RecipePickerSheet(
        buildingId: b.id,
        buildingData: widget.buildingData,
        recipes: recipes,
        l: l,
        isChange: true,
        currentRecipeId: b.selectedRecipeId,
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
        title: Text(
            '${buildingName(l, b.type.name)} — ${l.level}${b.level} → ${b.level + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatRow(l.upgradeTimeLabel,
                '${currentTime.toStringAsFixed(1)}s → ${nextTime.toStringAsFixed(1)}s'),
            _StatRow(l.upgradeCostLabel, cost.toGameFormat()),
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollCtrl) =>
            _ManagerSheet(building: b, scrollController: scrollCtrl),
      ),
    );
  }
}

// ─── Tarif seçilmemiş uyarı kartı ─────────────────────────────────────────

class _NoRecipeCard extends ConsumerWidget {
  final BuildingModel building;
  final BuildingData buildingData;
  final AppLocalizations l;
  const _NoRecipeCard(
      {required this.building, required this.buildingData, required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = JsonLoader.getRecipesForBuilding(buildingData.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.warning.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.warning, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${buildingName(l, building.type.name)} — Tarif seçilmedi',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.surface,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => _RecipePickerSheet(
                  buildingId: building.id,
                  buildingData: buildingData,
                  recipes: recipes,
                  l: l,
                ),
              ),
              child: const Text('Seç'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Yardımcı widget'lar ───────────────────────────────────────────────────

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
          Text(label,
              style: const TextStyle(color: AppColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
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
      child: Text(_label(l), style: TextStyle(color: _color, fontSize: 10)),
    );
  }
}

// ─── Yönetici bottom sheet ─────────────────────────────────────────────────

class _ManagerSheet extends ConsumerWidget {
  final BuildingModel building;
  final ScrollController scrollController;
  const _ManagerSheet(
      {required this.building, required this.scrollController});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l.assignManager,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: options.map((opt) {
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
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(mult,
                          style: TextStyle(
                            fontSize: 10,
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  title: Text(_levelName(l, lvl),
                      style: TextStyle(
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
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
                  enabled: !isCurrent &&
                      (lvl == ManagerLevel.none || canAfford),
                  onTap: isCurrent
                      ? null
                      : () {
                          Navigator.pop(context);
                          if (lvl == ManagerLevel.none) {
                            ref
                                .read(gameProvider.notifier)
                                .assignManager(building.id, lvl);
                          } else if (diamond > 0) {
                            if (ref
                                .read(gameProvider.notifier)
                                .spendDiamonds(diamond)) {
                              ref
                                  .read(gameProvider.notifier)
                                  .assignManager(building.id, lvl);
                            }
                          } else {
                            if (ref
                                .read(gameProvider.notifier)
                                .spendMoney(cost)) {
                              ref
                                  .read(gameProvider.notifier)
                                  .assignManager(building.id, lvl);
                            }
                          }
                        },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _levelName(AppLocalizations l, ManagerLevel lvl) => switch (lvl) {
        ManagerLevel.none     => l.managerNone,
        ManagerLevel.intern   => l.managerIntern,
        ManagerLevel.expert   => l.managerExpert,
        ManagerLevel.manager  => l.managerManager,
        ManagerLevel.director => l.managerDirector,
        ManagerLevel.ceo      => l.managerCEO,
      };
}
