import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../core/constants/app_colors.dart';

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
        return Dismissible(
          key: Key(tx.hashCode.toString()), // Benzersiz bir key
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('İşlemi Sil'),
                  content: const Text('Bu işlemi silmek istediğinizden emin misiniz?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                            'İptal',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Burayı istediğin renkle değiştirebilirsin
                     ),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                            'Sil',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Burayı istediğin renkle değiştirebilirsin
                     ),
                      ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            onDelete(tx);
          },
          child: Card(
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
                    '${tx.amount.toStringAsFixed(2)} ₺',
                    style: TextStyle(
                      color: tx.type == 'expense' ? const Color.fromARGB(255, 202, 32, 23) : AppColors.income,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: Colors.grey,
                    onPressed: () => onEdit(tx),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}