import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
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

  void _selectDate() {
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, now.day + 1);

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _DatePickerDialog(
        initialDate: selectedDate,
        maxDate: maxDate,
        onSelect: (date) {
          setState(() => selectedDate = date);
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
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
                                  DateFormat('d MMMM yyyy', 'tr_TR').format(selectedDate),
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
                        onPressed: selectedDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
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

class _DatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onCancel;

  const _DatePickerDialog({
    required this.initialDate,
    required this.maxDate,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  static const List<String> _monthNames = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate;
    _focusedDay = widget.initialDate;
  }

  int get _firstYear => 2000;
  int get _lastYear => widget.maxDate.year;

  void _goToYearMonth(int year, int month) {
    setState(() {
      _focusedDay = DateTime(year, month, 1);
      if (_focusedDay.isAfter(widget.maxDate)) {
        _focusedDay = widget.maxDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {}, // prevent tap from closing when tapping dialog
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 520),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tarih Seç',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: widget.onCancel,
                              icon: const Icon(Icons.close_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _DropdownTile<int>(
                                value: _focusedDay.year,
                                items: List.generate(
                                  _lastYear - _firstYear + 1,
                                  (i) => _lastYear - i,
                                ),
                                label: 'Yıl',
                                valueLabel: (v) => '$v',
                                onChanged: (year) => _goToYearMonth(year!, _focusedDay.month),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DropdownTile<int>(
                                value: _focusedDay.month,
                                items: List.generate(12, (i) => i + 1),
                                label: 'Ay',
                                valueLabel: (v) => _monthNames[v - 1],
                                onChanged: (month) => _goToYearMonth(_focusedDay.year, month!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final now = DateTime.now();
                            if (now.isBefore(widget.maxDate) || _isSameDay(now, widget.maxDate)) {
                              widget.onSelect(DateTime(now.year, now.month, now.day));
                            }
                          },
                          icon: const Icon(Icons.today_rounded, size: 20),
                          label: const Text('Bugün'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.income,
                            side: const BorderSide(color: AppColors.income),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                            child: TableCalendar(
                              locale: 'tr_TR',
                              firstDay: DateTime(_firstYear, 1, 1),
                              lastDay: widget.maxDate,
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                              onDaySelected: (day, _) {
                                if (!day.isAfter(widget.maxDate)) {
                                  widget.onSelect(day);
                                }
                              },
                              onPageChanged: (focused) {
                                setState(() => _focusedDay = focused);
                              },
                              calendarStyle: CalendarStyle(
                                selectedDecoration: BoxDecoration(
                                  color: AppColors.income,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.income.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                todayDecoration: BoxDecoration(
                                  color: AppColors.expense.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                weekendTextStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                outsideDaysVisible: false,
                                cellMargin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                leftChevronIcon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.income.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.chevron_left_rounded, color: AppColors.income, size: 20),
                                ),
                                rightChevronIcon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.income.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.chevron_right_rounded, color: AppColors.income, size: 20),
                                ),
                                headerPadding: const EdgeInsets.symmetric(vertical: 4),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: Theme.of(context).textTheme.bodySmall!,
                                weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DropdownTile<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String label;
  final String Function(T) valueLabel;
  final ValueChanged<T?> onChanged;

  const _DropdownTile({
    required this.value,
    required this.items,
    required this.label,
    required this.valueLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.income.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.income.withValues(alpha: 0.25)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.income),
          items: items.map((v) => DropdownMenuItem<T>(value: v, child: Text(valueLabel(v)))).toList(),
          onChanged: onChanged,
        ),
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