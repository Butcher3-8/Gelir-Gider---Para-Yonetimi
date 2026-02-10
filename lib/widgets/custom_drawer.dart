import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/backup_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  final List<String> languages = const [
    'Türkçe',
    'İngilizce',
    'Almanca',
    'Fransızca',
    'İspanyolca',
  ];

  final List<String> currencies = const [
    'TL',
    'Dolar',
    'Euro',
  ];

  final Map<String, String> currencySymbols = const {
    'TL': '₺',
    'Dolar': '\$',
    'Euro': '€',
  };

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF7F8FA),
              isDark ? const Color(0xFF1C1C1C) : const Color(0xFFEDEFF2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/fotoo.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gelir Gider Takip',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Menü',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Genel'),
              const SizedBox(height: 8),
              _card(
                context,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: const Icon(Icons.brightness_6, size: 24),
                  title: Text(
                    'Uygulama Teması',
                    style: textTheme.titleSmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDark ? Icons.nightlight_round : Icons.wb_sunny,
                        color: isDark ? Colors.amber[600] : Colors.orangeAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: isDark,
                        onChanged: (_) {
                          themeProvider.toggleTheme();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                child: ExpansionTile(
                  leading: const Icon(Icons.monetization_on, size: 24),
                  title: Text(
                    'Para Birimi',
                    style: textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    currencyProvider.currencySymbol,
                    style: textTheme.bodySmall,
                  ),
                  iconColor: Theme.of(context).iconTheme.color,
                  collapsedIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
                  childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
                  children: currencies.map((currency) {
                    final selected = currencyProvider.selectedCurrency == currency;
                    final symbol = currencySymbols[currency] ?? currency;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      title: Text(
                        symbol,
                        style: textTheme.bodyMedium?.copyWith(
                          color: selected ? Colors.blue[700] : textTheme.bodyMedium?.color,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      trailing: selected
                          ? Icon(Icons.check_rounded, color: Colors.blue[700], size: 18)
                          : null,
                      onTap: () {
                        currencyProvider.setCurrency(currency);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Yedekleme'),
              const SizedBox(height: 8),
              _card(
                context,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: const Icon(Icons.cloud_upload, size: 22),
                      title: Text(
                        'Dışa Aktar',
                        style: textTheme.bodyMedium,
                      ),
                      onTap: () => _exportBackup(context),
                    ),
                    Divider(
                      height: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: const Icon(Icons.cloud_download, size: 22),
                      title: Text(
                        'İçe Aktar',
                        style: textTheme.bodyMedium,
                      ),
                      onTap: () => _importBackup(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: const Icon(Icons.privacy_tip_outlined, size: 22),
                  title: Text(
                    'Gizlilik Politikası',
                    style: textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Yedek dosyasını kaydet',
        fileName: 'backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (filePath == null) {
        return;
      }

      await BackupService().saveBackupToFile(filePath);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Yedek kaydedildi: $filePath'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Yedekleme başarısız: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _importBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Yedek dosyasını seç',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.isEmpty) {
        return;
      }

      final filePath = result.files.single.path;
      if (filePath == null || filePath.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Dosya yolu alınamadı.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      await BackupService().restoreFromFile(filePath);
      await _showRestoreInfoDialog(context);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Geri yükleme başarısız: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showRestoreInfoDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Bilgilendirme'),
            ],
          ),
          content: const Text(
            'Yedekleme başarıyla içe aktarıldı.\n\n'
            'Değişikliklerin tamamen görünmesi için lütfen uygulamayı kapatıp yeniden açın.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}