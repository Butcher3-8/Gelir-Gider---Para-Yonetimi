import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5D9CEC),
                    Color(0xFF4A89DC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                      color: Color(0xFF4A89DC),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
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

            // Uygulama Teması
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined, color: Colors.black87),
              title: const Text('Uygulama Teması'),
              onTap: () {
                // TODO: Temayı değiştir
              },
            ),

            // Dil
            ListTile(
              leading: const Icon(Icons.language, color: Colors.black87),
              title: const Text('Dil'),
              onTap: () {
                // TODO: Dili değiştir
              },
            ),

            const Divider(),

            // Hakkında
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.black87),
              title: const Text('Hakkında'),
              onTap: () {
                // TODO: Hakkında sayfasına git
              },
            ),

            // Ayarlar
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black87),
              title: const Text('Ayarlar'),
              onTap: () {
                // TODO: Ayarlara git
              },
            ),

            // Uygulama
            ListTile(
              leading: const Icon(Icons.analytics_outlined, color: Colors.black87),
              title: const Text('Uygulama'),
              onTap: () {
                // TODO: Uygulama analiz sayfasına git
              },
            ),
          ],
        ),
      ),
    );
  }
}
