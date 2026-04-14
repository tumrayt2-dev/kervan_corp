import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../app.dart';
import '../core/constants.dart';
import '../providers/game_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _devMode;

  @override
  void initState() {
    super.initState();
    _devMode = ref.read(gameProvider.notifier).devMode;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isTr = currentLocale.languageCode == 'tr';
    final box = Hive.box('settings');

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dil
          _SectionHeader(title: l.language),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(l.languageTr,
                    style: TextStyle(
                      color: isTr ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isTr ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: !isTr,
                    activeThumbColor: AppColors.primary,
                    onChanged: (toEn) {
                      final langCode = toEn ? 'en' : 'tr';
                      box.put('language', langCode);
                      ref.read(localeProvider.notifier).state = Locale(langCode);
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(l.languageEn,
                    style: TextStyle(
                      color: !isTr ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: !isTr ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Ses
          _SectionHeader(title: l.sound),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ToggleRow(label: l.sound, value: true, onChanged: (_) {}),
                  const Divider(),
                  _ToggleRow(label: l.music, value: true, onChanged: (_) {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Geliştirici
          const _SectionHeader(title: '🛠 Geliştirici'),
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sonsuz Para',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _devMode ? '✅ Aktif — para düşmez' : 'Kapalı',
                            style: TextStyle(
                              fontSize: 11,
                              color: _devMode
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _devMode,
                        activeColor: AppColors.success,
                        onChanged: (v) {
                          setState(() => _devMode = v);
                          ref.read(gameProvider.notifier).setDevMode(v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('${l.version} 1.0.0',
              style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
      ],
    );
  }
}
