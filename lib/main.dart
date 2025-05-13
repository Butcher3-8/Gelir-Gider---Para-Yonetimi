import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router, // GoRouter yapılandırması burada
      debugShowCheckedModeBanner: false,
    );
  }
}
