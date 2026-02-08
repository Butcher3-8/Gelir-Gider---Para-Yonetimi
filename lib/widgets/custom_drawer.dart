import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFE0E0E0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF388E3C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/fotoo.png',
                      height: 90,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Menü',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(
                Icons.brightness_6,
                color: Theme.of(context).iconTheme.color,
                size: 28,
              ),
              title: Text(
                'Uygulama Teması',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    themeProvider.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: themeProvider.isDarkMode ? Colors.amber[600] : Colors.orangeAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ],
              ),
              hoverColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
              thickness: 0.5,
            ),
            ExpansionTile(
              leading: Icon(
                Icons.monetization_on,
                color: Theme.of(context).iconTheme.color,
                size: 28,
              ),
              title: Text(
                'Para Birimi: ${currencyProvider.selectedCurrency}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              iconColor: Theme.of(context).iconTheme.color,
              collapsedIconColor: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              childrenPadding: const EdgeInsets.only(left: 16),
              children: currencies.map((currency) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    currency,
                    style: TextStyle(
                      fontSize: 14,
                      color: currencyProvider.selectedCurrency == currency
                          ? Colors.blue[700]
                          : Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: currencyProvider.selectedCurrency == currency
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    currencyProvider.setCurrency(currency);
                    Navigator.pop(context);
                  },
                  hoverColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(
                Icons.contact_mail,
                color: Theme.of(context).iconTheme.color,
                size: 28,
              ),
              title: Text(
                'İletişim',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              hoverColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}