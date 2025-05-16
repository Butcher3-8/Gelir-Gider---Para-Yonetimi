import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionHistoryScreen({super.key, required this.transactions});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime selectedDate = DateTime.now();

  List<Transaction> get filteredTransactions {
    return widget.transactions.where((tx) =>
      tx.dateTime.year == selectedDate.year &&
      tx.dateTime.month == selectedDate.month &&
      tx.dateTime.day == selectedDate.day
    ).toList();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185), // ✅ Arka plan rengi
      appBar: AppBar(
  title: const Text("Geçmiş İşlemler"),
  backgroundColor: const Color.fromARGB(255, 185, 185, 185), // ✅ AppBar rengi düzeltildi
  elevation: 0, // Daha modern görünüm için istersen gölgeyi kaldırır
),
      body: Column(
        children: [
          const SizedBox(height: 16),
          TextButton(
            onPressed: _selectDate,
            child: Text(
              "Tarih Seç: ${DateFormat('dd MMMM yyyy', 'tr_TR').format(selectedDate)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // ✅ Siyah renk
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredTransactions.isEmpty
                ? const Center(child: Text("Bu tarihte işlem yok"))
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (ctx, i) {
                      final tx = filteredTransactions[i];
                      return ListTile(
                        leading: Icon(
                          tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                          color: tx.type == 'income' ? Colors.green : Colors.red,
                        ),
                        title: Text("${tx.category} - ${tx.description}"),
                        subtitle: Text(DateFormat('HH:mm').format(tx.dateTime)),
                        trailing: Text(
                          "${tx.amount.toStringAsFixed(2)}₺",
                          style: TextStyle(
                            color: tx.type == 'income' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
