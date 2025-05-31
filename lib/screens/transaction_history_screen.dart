import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';

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
        tx.dateTime.day == selectedDate.day).toList();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.income,
                  onPrimary: Colors.white,
                  onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
            dialogBackgroundColor: Theme.of(context).cardTheme.color,
            textButtonTheme: Theme.of(context).textButtonTheme,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).cardTheme.color,
              headerBackgroundColor: AppColors.income,
              headerForegroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              dayStyle: Theme.of(context).textTheme.bodyMedium,
              yearStyle: Theme.of(context).textTheme.bodyMedium,
              weekdayStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
              todayBorder: BorderSide(color: AppColors.income, width: 1),
              rangeSelectionBackgroundColor: AppColors.income.withOpacity(0.2),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _changeDate(bool isNext) {
    setState(() {
      selectedDate = isNext
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
      if (selectedDate.isAfter(DateTime.now().add(const Duration(days: 1)))) {
        selectedDate = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        title: Text(
          'Geçmiş İşlemler',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.26),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerTheme.color!, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20, color: AppColors.income),
                        onPressed: () => _changeDate(false),
                        splashRadius: 24,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: _selectDate,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              DateFormat('dd MMMM yyyy', 'tr_TR').format(selectedDate),
                              key: ValueKey(selectedDate),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: selectedDate.isBefore(DateTime.now())
                              ? AppColors.income
                              : Theme.of(context).disabledColor,
                        ),
                        onPressed: selectedDate.isBefore(DateTime.now()) ? () => _changeDate(true) : null,
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_toggle_off,
                            size: 80,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bu tarihte işlem yok',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Yeni bir gelir veya gider eklemeyi deneyin!',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (ctx, i) {
                      final tx = filteredTransactions[i];
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: Theme.of(context).cardTheme.elevation,
                          shape: Theme.of(context).cardTheme.shape,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: tx.type == 'income'
                                    ? AppColors.income.withOpacity(0.3)
                                    : AppColors.expense.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: tx.type == 'income' ? AppColors.income : AppColors.expense,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                tx.category,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    tx.description.isNotEmpty ? tx.description : 'Açıklama yok',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('HH:mm', 'tr_TR').format(tx.dateTime),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "${tx.type == 'income' ? '+' : '-'}${NumberFormat.currency(locale: 'tr_TR', symbol: currencyProvider.currencySymbol, decimalDigits: 2).format(tx.amount)}",
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: tx.type == 'income' ? AppColors.income : AppColors.expense,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: tx.type == 'income'
                                              ? AppColors.income.withOpacity(0.3)
                                              : AppColors.expense.withOpacity(0.3),
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (filteredTransactions.isNotEmpty)
            Divider(
              height: 1,
              thickness: Theme.of(context).dividerTheme.thickness,
              color: Theme.of(context).dividerTheme.color,
              indent: Theme.of(context).dividerTheme.indent,
              endIndent: Theme.of(context).dividerTheme.endIndent,
            ),
        ],
      ),
    );
  }
}