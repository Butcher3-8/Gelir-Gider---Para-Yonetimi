import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEEEEE),
              Color(0xFFDADADA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
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

            // Uygulama Teması satırı
            ListTile(
              leading: const Icon(Icons.brightness_6, color: Colors.black87),
              title: const Text('Uygulama Teması'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      color: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : Colors.orangeAccent),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                        // Şu an için sadece görsel olarak çalışıyor.
                      });
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // Dil Ayarı
            const ListTile(
              leading: Icon(Icons.language, color: Colors.black87),
              title: Text('Dil'),
            ),

            // İletişim
            const ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.black87),
              title: Text('İletişim'),
            ),
          ],
        ),
      ),
    );
  }
}
