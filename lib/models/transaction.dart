import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart' show HiveType, HiveField;

part 'transaction.g.dart'; // Bu dosya build_runner ile otomatik oluşturulacak

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String type; // 'income' veya 'expense'

  @HiveField(1)
  String category;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime dateTime;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.dateTime,
  });

  // Kopyalama constructor'ı (ihtiyaç duyarsanız)
  Transaction copyWith({
    String? type,
    String? category,
    double? amount,
    String? description,
    DateTime? dateTime,
  }) {
    return Transaction(
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}