import 'package:flutter/material.dart';
import 'core/routes.dart'; // router dosyan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gelir Gider Takip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router, // GoRouter yapılandırması burada
      debugShowCheckedModeBanner: false,
    );
  }
}
