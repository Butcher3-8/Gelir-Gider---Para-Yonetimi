import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 185, 185, 185),
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Uygulama'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ayarlar'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Hakkında'),
          ),
        ],
      ),
    );
  }
}
