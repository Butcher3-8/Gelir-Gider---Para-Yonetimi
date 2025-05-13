import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatı için gerekli
import '../models/transaction.dart';
import '../core/constants/app_colors.dart';

class LastTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const LastTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Henüz işlem yok',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transactions.reversed.take(5).map((tx) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: tx.type == 'expense' ? AppColors.expense : AppColors.income,
            child: Icon(
              tx.type == 'expense' ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
          title: Text(tx.category),
          subtitle: Text(tx.description),
          trailing: Text(
            '${tx.amount.toStringAsFixed(2)} ₺',
            style: TextStyle(
              color: tx.type == 'expense' ? AppColors.expense : AppColors.income,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}
