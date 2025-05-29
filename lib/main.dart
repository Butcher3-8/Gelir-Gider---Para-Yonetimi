import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/routes.dart'; // router dosyan
import 'models/transaction.dart'; // Transaction modelin

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive'ı başlat
  await Hive.initFlutter();

  // Transaction adapter'ını kaydet
  Hive.registerAdapter(TransactionAdapter());

  // Türkçe tarih formatını başlat
  await initializeDateFormatting('tr_TR', null);

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
