import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';

class LastTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onDelete;
  final Function(Transaction) onEdit;

  const LastTransactions({
    super.key, 
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

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

    // En son eklenen işlemler en üstte gösterilecek
    final displayedTransactions = transactions.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayedTransactions.map((tx) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tx.type == 'expense' ? AppColors.expense : AppColors.income,
              child: Icon(
                tx.type == 'expense' ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
            title: Text(
              tx.category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description),
                Text(
                  DateFormat('dd.MM.yyyy - HH:mm').format(tx.dateTime),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  NumberFormat.currency(
                    locale: 'tr_TR',
                    symbol: currencyProvider.currencySymbol,
                    decimalDigits: 2,
                  ).format(tx.amount),
                  style: TextStyle(
                    color: tx.type == 'expense' ? AppColors.expense : AppColors.income,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.grey,
                  onPressed: () => onEdit(tx),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, tx),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, Transaction tx) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'İşlemi Sil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Bu işlemi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'İptal',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: Colors.red[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                onDelete(tx);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Sil',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 8,
        );
      },
    );
  }
}