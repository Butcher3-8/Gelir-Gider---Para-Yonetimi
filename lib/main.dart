import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/routes.dart';
import 'models/transaction.dart';
import 'providers/currency_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox('settings'); // Open settings box for theme persistence

  // Initialize Turkish date formatting
  await initializeDateFormatting('tr_TR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Gelir Gider Takip',
            theme: themeProvider.currentTheme,
            locale: const Locale('tr', 'TR'),
            supportedLocales: const [
              Locale('tr', 'TR'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return AnimatedTheme(
                data: themeProvider.currentTheme,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}