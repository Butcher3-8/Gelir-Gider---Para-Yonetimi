import 'package:flutter/material.dart';

class CurrencyProvider with ChangeNotifier {
  String _selectedCurrency = 'TL';
  final Map<String, String> _currencySymbols = {
    'TL': '₺',
    'Dolar': '\$',
    'Euro': '€',
  };

  String get selectedCurrency => _selectedCurrency;
  String get currencySymbol => _currencySymbols[_selectedCurrency] ?? '₺';

  void setCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
}