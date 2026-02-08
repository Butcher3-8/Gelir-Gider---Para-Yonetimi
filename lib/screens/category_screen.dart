import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';
import '../providers/currency_provider.dart';
import '../widgets/date_picker_dialog.dart';

class CategoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const CategoryScreen({
    super.key,
    required this.transactions,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  DateTime _selectedMonth = DateTime.now();

  final List<String> _expenseCategories = [
    'Yiyecek', 'Ulaşım', 'Fatura', 'Alışveriş', 
    'Verilen Borç', 'Eğlence', 'Diğer'
  ];

  final List<String> _incomeCategories = [
    'Maaş', 'Burs', 'Harçlık', 'Ek Gelir', 'Alınan Borç', 'Diğer'
  ];

  Map<String, double> _calculateCategoryExpenses() {
    Map<String, double> categoryExpenses = {};

    for (String category in _expenseCategories) {
      categoryExpenses[category] = 0.0;
    }

    List<Transaction> monthlyExpenses = widget.transactions.where((transaction) {
      return transaction.type == 'expense' &&
             transaction.dateTime.year == _selectedMonth.year &&
             transaction.dateTime.month == _selectedMonth.month;
    }).toList();

    for (Transaction transaction in monthlyExpenses) {
      if (categoryExpenses.containsKey(transaction.category)) {
        categoryExpenses[transaction.category] = 
            categoryExpenses[transaction.category]! + transaction.amount;
      }
    }

    return categoryExpenses;
  }

  Map<String, double> _calculateCategoryIncomes() {
    Map<String, double> categoryIncomes = {};

    for (String category in _incomeCategories) {
      categoryIncomes[category] = 0.0;
    }

    List<Transaction> monthlyIncomes = widget.transactions.where((transaction) {
      return transaction.type == 'income' &&
             transaction.dateTime.year == _selectedMonth.year &&
             transaction.dateTime.month == _selectedMonth.month;
    }).toList();

    for (Transaction transaction in monthlyIncomes) {
      if (categoryIncomes.containsKey(transaction.category)) {
        categoryIncomes[transaction.category] = 
            categoryIncomes[transaction.category]! + transaction.amount;
      }
    }

    return categoryIncomes;
  }

  double _calculateTotalExpenses() {
    Map<String, double> expenses = _calculateCategoryExpenses();
    return expenses.values.fold(0.0, (sum, amount) => sum + amount);
  }

  double _calculateTotalIncomes() {
    Map<String, double> incomes = _calculateCategoryIncomes();
    return incomes.values.fold(0.0, (sum, amount) => sum + amount);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    if (_selectedMonth.year < now.year || _selectedMonth.month < now.month) {
      setState(() {
        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      });
    }
  }

  bool get _canGoNextMonth {
    final now = DateTime.now();
    return _selectedMonth.year < now.year ||
        (_selectedMonth.year == now.year && _selectedMonth.month < now.month);
  }

  void _openDatePicker() {
    final now = DateTime.now();
    final maxDate = DateTime(now.year, now.month, now.day);

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => AppDatePickerDialog(
        initialDate: DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        maxDate: maxDate,
        onSelect: (date) {
          setState(() {
            _selectedMonth = DateTime(date.year, date.month);
          });
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCategoryCard(String category, double amount, bool isExpense, String currencySymbol) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$category :',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            NumberFormat.currency(
              locale: 'tr_TR',
              symbol: currencySymbol,
              decimalDigits: 0,
            ).format(amount),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: isExpense ? AppColors.expense : AppColors.income,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    Map<String, double> categoryExpenses = _calculateCategoryExpenses();
    Map<String, double> categoryIncomes = _calculateCategoryIncomes();
    double totalExpenses = _calculateTotalExpenses();
    double totalIncomes = _calculateTotalIncomes();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme!.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kategori Raporu',
          style: Theme.of(context).appBarTheme.titleTextStyle,
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
                onTap: _openDatePicker,
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
                      _CategoryNavButton(
                        icon: Icons.chevron_left_rounded,
                        onPressed: _previousMonth,
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
                              child: Text(
                                DateFormat('MMMM yyyy', 'tr_TR').format(_selectedMonth),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _CategoryNavButton(
                        icon: Icons.chevron_right_rounded,
                        onPressed: _canGoNextMonth ? _nextMonth : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Toplam Gelir',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.income,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'tr_TR',
                            symbol: currencyProvider.currencySymbol,
                            decimalDigits: 0,
                          ).format(totalIncomes),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: AppColors.income,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Toplam Gider',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.expense,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'tr_TR',
                            symbol: currencyProvider.currencySymbol,
                            decimalDigits: 0,
                          ).format(totalExpenses),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Net',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'tr_TR',
                            symbol: currencyProvider.currencySymbol,
                            decimalDigits: 0,
                          ).format(totalIncomes - totalExpenses),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: (totalIncomes - totalExpenses) >= 0 
                                    ? AppColors.income 
                                    : AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.income,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.income, width: 2),
                          ),
                          child: const Text(
                            'GELİR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...categoryIncomes.entries.map((entry) =>
                            _buildCategoryCard(entry.key, entry.value, false, currencyProvider.currencySymbol)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.expense,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.expense, width: 2),
                          ),
                          child: const Text(
                            'GİDER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...categoryExpenses.entries.map((entry) =>
                            _buildCategoryCard(entry.key, entry.value, true, currencyProvider.currencySymbol)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CategoryNavButton({required this.icon, this.onPressed});

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