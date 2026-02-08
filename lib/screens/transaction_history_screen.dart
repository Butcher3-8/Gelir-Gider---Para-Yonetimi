import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';
import '../widgets/date_picker_dialog.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const TransactionHistoryScreen({super.key, required this.transactions});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  /// Seçilen ay (gün her zaman 1 kullanılır, sadece yıl/ay önemli).
  DateTime selectedDate = DateTime.now();

  List<Transaction> get filteredTransactions {
    return widget.transactions.where((tx) =>
        tx.dateTime.year == selectedDate.year &&
        tx.dateTime.month == selectedDate.month).toList();
  }

  void _selectDate() {
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, 1);

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => AppDatePickerDialog(
        initialDate: selectedDate,
        maxDate: maxDate,
        onSelect: (date) {
          setState(() => selectedDate = DateTime(date.year, date.month, 1));
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _changeDate(bool isNext) {
    setState(() {
      if (isNext) {
        if (selectedDate.year < DateTime.now().year ||
            selectedDate.month < DateTime.now().month) {
          selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
        }
      } else {
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.income.withValues(alpha: 0.12),
                        AppColors.expense.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.income.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.income.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavButton(
                        icon: Icons.chevron_left_rounded,
                        onPressed: () => _changeDate(false),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.income.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.income,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(
                                  DateFormat('MMMM yyyy', 'tr_TR').format(selectedDate),
                                  key: ValueKey(selectedDate),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _NavButton(
                        icon: Icons.chevron_right_rounded,
                        onPressed: (selectedDate.year < DateTime.now().year ||
                                selectedDate.month < DateTime.now().month)
                            ? () => _changeDate(true)
                            : null,
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

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isEnabled
                ? AppColors.income.withValues(alpha: 0.15)
                : Theme.of(context).disabledColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: isEnabled ? AppColors.income : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}