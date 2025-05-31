import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkMode = false;
  final List<String> languages = [
    'Türkçe',
    'İngilizce',
    'Almanca',
    'Fransızca',
    'İspanyolca',
  ];

  final List<String> currencies = [
    'TL',
    'Dolar',
    'Euro',
  ];

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFE0E0E0),
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
                color: Colors.grey[800],
                size: 28,
              ),
              title: const Text(
                'Uygulama Teması',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: isDarkMode ? Colors.amber[600] : Colors.orangeAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Switch(
                      key: ValueKey<bool>(isDarkMode),
                      value: isDarkMode,
                      activeColor: Colors.amber[600],
                      inactiveThumbColor: Colors.grey[400],
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              hoverColor: Colors.grey[200],
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
                color: Colors.grey[800],
                size: 28,
              ),
              title: Text(
                'Para Birimi: ${currencyProvider.selectedCurrency}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              iconColor: Colors.grey[800],
              collapsedIconColor: Colors.grey[600],
              childrenPadding: const EdgeInsets.only(left: 16),
              children: currencies.map((currency) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    currency,
                    style: TextStyle(
                      fontSize: 14,
                      color: currencyProvider.selectedCurrency == currency ? Colors.blue[700] : Colors.black87,
                      fontWeight: currencyProvider.selectedCurrency == currency ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    currencyProvider.setCurrency(currency);
                    Navigator.pop(context);
                  },
                  hoverColor: Colors.grey[200],
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
                color: Colors.grey[800],
                size: 28,
              ),
              title: const Text(
                'İletişim',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              hoverColor: Colors.grey[200],
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