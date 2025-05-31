import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.income,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
      titleLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.income,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.income,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: Colors.black87),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(4),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.income),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.income.withOpacity(0.9),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF2D2D2D),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.income,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.income,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: Colors.white70),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF2D2D2D)),
        elevation: WidgetStateProperty.all(4),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.income),
      ),
    ),
  );
}