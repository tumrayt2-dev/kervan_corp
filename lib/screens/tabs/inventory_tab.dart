import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/extensions.dart';
import '../../core/localization_helpers.dart';
import '../../data/json_loader.dart';
import '../../l10n/app_localizations.dart';
import '../../models/enums.dart';
import '../../models/inventory_model.dart';
import '../../models/product_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/inventory_provider.dart';

enum _SortMode { quantity, value }

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends ConsumerState<InventoryTab> {
  ProductCategory? _filter;
  bool _hideZero = false;
  _SortMode _sort = _SortMode.value;

  List<InventorySlot> _buildList(Inventory inventory) {
    var slots = inventory.slots.values.toList();

    if (_filter != null) {
      slots = slots.where((s) {
        final p = JsonLoader.getProduct(s.productType);
        return p?.category == _filter;
      }).toList();
    }

    if (_hideZero) {
      slots = slots.where((s) => s.quantity > 0).toList();
    }

    switch (_sort) {
      case _SortMode.quantity:
        slots.sort((a, b) => b.quantity.compareTo(a.quantity));
      case _SortMode.value:
        slots.sort((a, b) {
          final pA = JsonLoader.getProduct(a.productType)?.baseValue ?? 0;
          final pB = JsonLoader.getProduct(b.productType)?.baseValue ?? 0;
          return (b.quantity * pB).compareTo(a.quantity * pA);
        });
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final inventory = ref.watch(inventoryProvider);
    final game = ref.watch(gameProvider);
    final slots = _buildList(inventory);

    return Column(
      children: [
        _WarehouseBar(
          inventory: inventory,
          warehouseLevel: game.warehouseLevel,
          maxCapacity: game.maxInventoryCapacity,
          nextCost: game.nextWarehouseUpgradeCost,
          l: l,
          onUpgrade: () => _onUpgrade(game.warehouseLevel, game.nextWarehouseUpgradeCost),
        ),
        _ControlRow(
          hideZero: _hideZero,
          sort: _sort,
          l: l,
          onToggleHide: () => setState(() => _hideZero = !_hideZero),
          onSort: (m) => setState(() => _sort = m),
        ),
        _FilterRow(
          selected: _filter,
          onSelect: (c) => setState(() => _filter = c),
          l: l,
        ),
        Expanded(
          child: slots.isEmpty
              ? Center(
                  child: Text(
                    _hideZero ? l.comingSoon : l.comingSoon,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: slots.length,
                  itemBuilder: (ctx, i) => _ProductRow(
                    slot: slots[i],
                    l: l,
                  ),
                ),
        ),
      ],
    );
  }

  void _onUpgrade(int currentLevel, double? cost) {
    if (cost == null) return;
    final ok = ref.read(gameProvider.notifier).upgradeWarehouse();
    if (ok) {
      final newMax = ref.read(gameProvider).maxInventoryCapacity.toDouble();
      ref.read(inventoryProvider.notifier).updateMaxCapacity(newMax);
    }
  }
}

// ─── Depo / kapasite başlık barı ─────────────────────────────────────────────

class _WarehouseBar extends StatelessWidget {
  final Inventory inventory;
  final int warehouseLevel;
  final int maxCapacity;
  final double? nextCost;
  final AppLocalizations l;
  final VoidCallback onUpgrade;

  const _WarehouseBar({
    required this.inventory,
    required this.warehouseLevel,
    required this.maxCapacity,
    required this.nextCost,
    required this.l,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final fill = inventory.maxTotalWeight > 0
        ? inventory.totalWeight / maxCapacity
        : 0.0;
    final fillPct = (fill * 100).toStringAsFixed(0);
    final isWarning = fill >= 0.85;
    final barColor = isWarning ? AppColors.error : AppColors.primary;

    // Toplam değer
    double totalValue = 0;
    for (final slot in inventory.slots.values) {
      final p = JsonLoader.getProduct(slot.productType);
      if (p != null) totalValue += slot.quantity * p.baseValue;
    }

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      child: Row(
        children: [
          // Sol: depo seviyesi + fill bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      l.warehouseLv(warehouseLevel),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${inventory.totalWeight.toStringAsFixed(0)} / $maxCapacity  •  $fillPct%',
                      style: TextStyle(
                        fontSize: 11,
                        color: isWarning ? AppColors.error : AppColors.textSecondary,
                        fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: fill.clamp(0.0, 1.0),
                    minHeight: 5,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l.inventoryTotalValue}: ${totalValue.toGameFormat()}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Sağ: yükselt butonu
          if (nextCost != null)
            ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.upgradeWarehouseBtn,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    nextCost!.toGameFormat(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.warehouseMaxLv,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Kontrol satırı (gizle + sırala) ─────────────────────────────────────────

class _ControlRow extends StatelessWidget {
  final bool hideZero;
  final _SortMode sort;
  final AppLocalizations l;
  final VoidCallback onToggleHide;
  final ValueChanged<_SortMode> onSort;

  const _ControlRow({
    required this.hideZero,
    required this.sort,
    required this.l,
    required this.onToggleHide,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          // Sıfır gizle toggle
          InkWell(
            onTap: onToggleHide,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hideZero ? Icons.visibility_off : Icons.visibility,
                    size: 14,
                    color: hideZero ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hideZero ? l.showZeroStock : l.hideZeroStock,
                    style: TextStyle(
                      fontSize: 11,
                      color: hideZero ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Sırala butonları
          const Text(
            'Sırala: ',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          _SortBtn(
            label: l.sortByValue,
            active: sort == _SortMode.value,
            onTap: () => onSort(_SortMode.value),
          ),
          const SizedBox(width: 4),
          _SortBtn(
            label: l.sortByQuantity,
            active: sort == _SortMode.quantity,
            onTap: () => onSort(_SortMode.quantity),
          ),
        ],
      ),
    );
  }
}

class _SortBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SortBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? AppColors.primary : AppColors.textSecondary,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ─── Filtre chip satırı ───────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;
  final AppLocalizations l;

  const _FilterRow({
    required this.selected,
    required this.onSelect,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <ProductCategory?, String>{
      null: l.filterAll,
      ProductCategory.rawAgri: l.filterRawAgri,
      ProductCategory.rawAnimal: l.filterRawAnimal,
      ProductCategory.rawMining: l.filterRawMining,
      ProductCategory.rawForest: l.filterRawForest,
      ProductCategory.processed: l.filterProcessed,
      ProductCategory.manufactured: l.filterManufactured,
    };

    return Container(
      color: AppColors.surface,
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: filters.entries.map((e) {
          final isSelected = e.key == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Ürün satırı ─────────────────────────────────────────────────────────────

class _ProductRow extends ConsumerWidget {
  final InventorySlot slot;
  final AppLocalizations l;
  const _ProductRow({required this.slot, required this.l});

  Color _barColor(double fill) {
    if (fill >= 0.85) return AppColors.error;
    if (fill >= 0.60) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = JsonLoader.getProduct(slot.productType);
    if (product == null) return const SizedBox.shrink();

    final fill = slot.maxCapacity > 0 ? slot.quantity / slot.maxCapacity : 0.0;
    final isEmpty = slot.quantity <= 0;
    final totalVal = slot.quantity * product.baseValue;
    final emoji = productEmoji(slot.productType);

    return Opacity(
      opacity: isEmpty ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // Emoji ikon
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 10),

              // Orta: isim + bar + miktar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            productName(l, slot.productType),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          slot.quantity.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: fill.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(_barColor(fill)),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _CategoryBadge(category: product.category, l: l),
                        const Spacer(),
                        Text(
                          totalVal > 0 ? totalVal.toGameFormat() : '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (slot.reservedQty > 0)
                      Text(
                        l.reservedNote(slot.reservedQty.toStringAsFixed(0)),
                        style: const TextStyle(fontSize: 9, color: AppColors.warning),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Sat butonu
              SizedBox(
                width: 44,
                child: OutlinedButton(
                  onPressed: isEmpty
                      ? null
                      : () => _showSellSheet(context, ref, product, slot),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: isEmpty ? AppColors.border : AppColors.primary,
                    ),
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(l.sell, style: const TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSellSheet(BuildContext context, WidgetRef ref,
      ProductModel product, InventorySlot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _SellSheet(product: product, slot: slot),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final ProductCategory category;
  final AppLocalizations l;
  const _CategoryBadge({required this.category, required this.l});

  Color get _color => switch (category) {
        ProductCategory.rawAgri      => const Color(0xFF81C784),
        ProductCategory.rawAnimal    => const Color(0xFFFFB74D),
        ProductCategory.rawMining    => const Color(0xFF90A4AE),
        ProductCategory.rawForest    => const Color(0xFF66BB6A),
        ProductCategory.processed    => AppColors.accent,
        ProductCategory.manufactured => AppColors.secondary,
      };

  // Strip the emoji prefix from filter labels for compact badge display
  String _label() => switch (category) {
        ProductCategory.rawAgri      => l.filterRawAgri.replaceAll('🌾 ', ''),
        ProductCategory.rawAnimal    => l.filterRawAnimal.replaceAll('🐄 ', ''),
        ProductCategory.rawMining    => l.filterRawMining.replaceAll('⛏️ ', ''),
        ProductCategory.rawForest    => l.filterRawForest.replaceAll('🌲 ', ''),
        ProductCategory.processed    => l.filterProcessed.replaceAll('⚙️ ', ''),
        ProductCategory.manufactured => l.filterManufactured.replaceAll('📦 ', ''),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _label(),
        style: TextStyle(fontSize: 9, color: _color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Satış bottom sheet ───────────────────────────────────────────────────────

class _SellSheet extends ConsumerStatefulWidget {
  final ProductModel product;
  final InventorySlot slot;
  const _SellSheet({required this.product, required this.slot});

  @override
  ConsumerState<_SellSheet> createState() => _SellSheetState();
}

class _SellSheetState extends ConsumerState<_SellSheet> {
  SaleChannel? _selectedChannel;
  double _qty = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableSaleChannels.isNotEmpty) {
      _selectedChannel = widget.product.availableSaleChannels.first.channel;
    }
    _qty = widget.slot.available.clamp(1, widget.slot.available);
  }

  double get _available => widget.slot.available;

  double get _unitPrice {
    if (_selectedChannel == null) return 0;
    return widget.product.salePrice(_selectedChannel!);
  }

  double get _totalRevenue => _qty * _unitPrice;

  String _channelName(AppLocalizations l, SaleChannel ch) => switch (ch) {
        SaleChannel.market          => l.channel_market,
        SaleChannel.supermarket     => l.channel_supermarket,
        SaleChannel.furnitureStore  => l.channel_furnitureStore,
        SaleChannel.clothingStore   => l.channel_clothingStore,
        SaleChannel.electronicStore => l.channel_electronicStore,
        SaleChannel.industrialStore => l.channel_industrialStore,
        SaleChannel.restaurant      => l.channel_restaurant,
        SaleChannel.port            => l.channel_port,
        SaleChannel.airCargoTerminal => l.channel_airCargoTerminal,
      };

  void _executeSell(double qty) {
    if (_selectedChannel == null || qty <= 0) return;
    final revenue = ref
        .read(inventoryProvider.notifier)
        .sellFromInventory(widget.product.type, qty, _selectedChannel!);
    ref.read(gameProvider.notifier).addMoney(revenue);
    _showMoneyFlyUp(revenue);
    Navigator.pop(context);
  }

  void _showMoneyFlyUp(double amount) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (ctx) => _MoneyFlyUp(amount: amount),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 900), entry.remove);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final channels = widget.product.availableSaleChannels;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tutaç
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Başlık
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${productEmoji(widget.product.type)}  ${productName(l, widget.product.type)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${l.available}: ${_available.toStringAsFixed(0)} ${l.units}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Kanal seçici
            ...channels.map((ch) {
              final isSelected = ch.channel == _selectedChannel;
              final price = widget.product.baseValue * ch.multiplier;
              return InkWell(
                onTap: () => setState(() {
                  _selectedChannel = ch.channel;
                  _qty = _available.clamp(1, _available);
                }),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  title: Text(
                    _channelName(l, ch.channel),
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '×${ch.multiplier.toStringAsFixed(1)}  →  ${price.toGameFormat()}/${l.units}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary, size: 18)
                      : null,
                ),
              );
            }),

            const Divider(height: 1),

            // Miktar slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_qty.toStringAsFixed(0)} ${l.units}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${l.estimatedRevenue}: ${_totalRevenue.toGameFormat()}',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _qty.clamp(0, _available > 0 ? _available : 1),
                    min: 0,
                    max: _available > 0 ? _available : 1,
                    divisions: _available > 1 ? _available.toInt() : 1,
                    activeColor: AppColors.primary,
                    onChanged: _available > 0
                        ? (v) => setState(() => _qty = v)
                        : null,
                  ),
                ],
              ),
            ),

            // Butonlar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _available > 0 ? () => _executeSell(_available) : null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                      ),
                      child: Text(
                        l.sellAll(_available.toStringAsFixed(0)),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _qty > 0 ? () => _executeSell(_qty) : null,
                      child: Text(
                        '${l.sell} → ${_totalRevenue.toGameFormat()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── +Para fly-up animasyonu ──────────────────────────────────────────────────

class _MoneyFlyUp extends StatefulWidget {
  final double amount;
  const _MoneyFlyUp({required this.amount});

  @override
  State<_MoneyFlyUp> createState() => _MoneyFlyUpState();
}

class _MoneyFlyUpState extends State<_MoneyFlyUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0)),
    );
    _offset = Tween(begin: 0.0, end: -60.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) => Transform.translate(
          offset: Offset(0, _offset.value),
          child: Opacity(
            opacity: _opacity.value,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${widget.amount.toGameFormat()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
