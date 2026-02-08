import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';

import '../models/transaction.dart';

class BackupService {
  static const int currentVersion = 1;
  static const String transactionsBoxName = 'transactions';
  static const String settingsBoxName = 'settings';

  Future<String> createBackupJson() async {
    final payload = await _createBackupPayload();
    return jsonEncode(payload);
  }

  Future<void> saveBackupToFile(String filePath) async {
    final json = await createBackupJson();
    final file = File(filePath);
    await file.writeAsString(json);
  }

  Future<void> restoreFromJson(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup format is invalid.');
    }
    await _restoreFromPayload(decoded);
  }

  Future<void> restoreFromFile(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    await restoreFromJson(jsonString);
  }

  Future<Map<String, dynamic>> _createBackupPayload() async {
    final transactionsBox = await _openTransactionsBox();
    final settingsBox = await _openSettingsBox();

    final transactions = transactionsBox.values
        .map((transaction) => _transactionToMap(transaction))
        .toList();

    final settings = <String, dynamic>{};
    for (final key in settingsBox.keys) {
      settings[key.toString()] = settingsBox.get(key);
    }

    return {
      'version': currentVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'data': {
        'transactions': transactions,
        'settings': settings,
      },
    };
  }

  Future<void> _restoreFromPayload(Map<String, dynamic> payload) async {
    final version = payload['version'];
    if (version is! int || version != currentVersion) {
      throw const FormatException('Backup version is not supported.');
    }

    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Backup data is missing.');
    }

    final transactionsRaw = data['transactions'];
    final settingsRaw = data['settings'];

    if (transactionsRaw is! List<dynamic> || settingsRaw is! Map<String, dynamic>) {
      throw const FormatException('Backup data structure is invalid.');
    }

    final transactionsBox = await _openTransactionsBox();
    final settingsBox = await _openSettingsBox();

    await transactionsBox.clear();
    for (final item in transactionsRaw) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Transaction data is invalid.');
      }
      final transaction = _transactionFromMap(item);
      await transactionsBox.add(transaction);
    }

    await settingsBox.clear();
    for (final entry in settingsRaw.entries) {
      await settingsBox.put(entry.key, entry.value);
    }
  }

  Map<String, dynamic> _transactionToMap(Transaction transaction) {
    return {
      'type': transaction.type,
      'category': transaction.category,
      'amount': transaction.amount,
      'description': transaction.description,
      'dateTime': transaction.dateTime.toIso8601String(),
    };
  }

  Transaction _transactionFromMap(Map<String, dynamic> map) {
    final amount = map['amount'];
    final dateTime = map['dateTime'];
    if (amount is! num || dateTime is! String) {
      throw const FormatException('Transaction fields are invalid.');
    }

    return Transaction(
      type: map['type']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      amount: amount.toDouble(),
      description: map['description']?.toString() ?? '',
      dateTime: DateTime.parse(dateTime),
    );
  }

  Future<Box<Transaction>> _openTransactionsBox() async {
    if (Hive.isBoxOpen(transactionsBoxName)) {
      return Hive.box<Transaction>(transactionsBoxName);
    }
    return Hive.openBox<Transaction>(transactionsBoxName);
  }

  Future<Box> _openSettingsBox() async {
    if (Hive.isBoxOpen(settingsBoxName)) {
      return Hive.box(settingsBoxName);
    }
    return Hive.openBox(settingsBoxName);
  }
}
