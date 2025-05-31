import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/expense_popup.dart';
import '../widgets/income_popup.dart';
import '../widgets/last_transactions.dart';
import '../models/transaction.dart';
import '../screens/transaction_history_screen.dart';
import '../screens/category_screen.dart';
import '../providers/currency_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _expenseScale = 1.0;
  double _incomeScale = 1.0;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isExpensePopupVisible = false;
  bool _isIncomePopupVisible = false;
  bool _isEditMode = false;
  late Transaction _transactionToEdit;

  late Box<Transaction> _transactionBox;
  List<Transaction> _transactions = [];
  
  late Map<DateTime, List<Transaction>> _events;
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
    _openBox();
  }

  Future<void> _openBox() async {
    _transactionBox = await Hive.openBox<Transaction>('transactions');
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _transactions = _transactionBox.values.toList();
      _updateEvents();
    });
  }

  Future<void> _saveTransaction(Transaction transaction) async {
    await _transactionBox.add(transaction);
    _loadTransactions();
  }

  Future<void> _updateTransactionInBox(Transaction oldTransaction, Transaction newTransaction) async {
    final index = _transactionBox.values.toList().indexOf(oldTransaction);
    if (index != -1) {
      await _transactionBox.putAt(index, newTransaction);
      _loadTransactions();
    }
  }

  Future<void> _deleteTransactionFromBox(Transaction transaction) async {
    final index = _transactionBox.values.toList().indexOf(transaction);
    if (index != -1) {
      await _transactionBox.deleteAt(index);
      _loadTransactions();
    }
  }

  void _onTapDown(String type) {
    setState(() {
      if (type == 'expense') {
        _expenseScale = 0.95;
      } else {
        _incomeScale = 0.95;
      }
    });
  }

  void _onTapUp(String type) {
    setState(() {
      if (type == 'expense') {
        _expenseScale = 1.0;
      } else {
        _incomeScale = 1.0;
      }
    });
  }

  void _deleteTransaction(Transaction transaction) {
    _deleteTransactionFromBox(transaction);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('İşlem silindi'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Geri Al',
          textColor: Colors.white,
          onPressed: () {
            _saveTransaction(transaction);
          },
        ),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    setState(() {
      _isEditMode = true;
      _transactionToEdit = transaction;
      
      if (transaction.type == 'expense') {
        _isExpensePopupVisible = true;
      } else {
        _isIncomePopupVisible = true;
      }
    });
  }

  void _updateTransaction(Transaction updatedTransaction) {
    _updateTransactionInBox(_transactionToEdit, updatedTransaction);
    setState(() {
      _isEditMode = false;
    });
  }

  double _calculateBalance() {
    double income = _transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, item) => sum + item.amount);
    
    double expense = _transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, item) => sum + item.amount);
    
    return income - expense;
  }
  
  void _updateEvents() {
    _events = {};
    for (var transaction in _transactions) {
      final eventDate = DateTime(
        transaction.dateTime.year,
        transaction.dateTime.month,
        transaction.dateTime.day,
      );
      
      if (_events[eventDate] != null) {
        _events[eventDate]!.add(transaction);
      } else {
        _events[eventDate] = [transaction];
      }
    }
  }
  
  List<Transaction> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }
  
  Widget _buildMarkers(DateTime day, List<Transaction> events) {
    if (events.isEmpty) return Container();
    
    bool hasIncome = events.any((tx) => tx.type == 'income');
    bool hasExpense = events.any((tx) => tx.type == 'expense');
    
    return Positioned(
      bottom: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIncome)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.income,
              ),
            ),
          if (hasExpense)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.expense,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Hive.box<Transaction>('transactions').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    _updateEvents();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Gelir Gider Yönetimi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(transactions: _transactions),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.income.withOpacity(0.8),
                          AppColors.expense.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Toplam Bakiyeniz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(
                            locale: 'tr_TR',
                            symbol: currencyProvider.currencySymbol,
                            decimalDigits: 2,
                          ).format(_calculateBalance()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TableCalendar(
                      locale: 'tr_TR',
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppColors.income,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.expense.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: const TextStyle(color: Colors.red),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black54),
                        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black54),
                      ),
                      eventLoader: _getEventsForDay,
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          final txEvents = events.cast<Transaction>();
                          return _buildMarkers(day, txEvents);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Son İşlemler',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionHistoryScreen(transactions: _transactions),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "Daha Fazla",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _transactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64,
                              color: Colors.black26,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Henüz bir işlem yok',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SingleChildScrollView(
                          child: LastTransactions(
                            transactions: _transactions,
                            onDelete: _deleteTransaction,
                            onEdit: _editTransaction,
                          ),
                        ),
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => _onTapDown('expense'),
                          onTapUp: (_) => _onTapUp('expense'),
                          onTapCancel: () => _onTapUp('expense'),
                          onTap: () {
                            setState(() {
                              _isEditMode = false;
                              _isExpensePopupVisible = true;
                            });
                          },
                          child: AnimatedScale(
                            scale: _expenseScale,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.expense,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.expense.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Gider Ekle',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => _onTapDown('income'),
                          onTapUp: (_) => _onTapUp('income'),
                          onTapCancel: () => _onTapUp('income'),
                          onTap: () {
                            setState(() {
                              _isEditMode = false;
                              _isIncomePopupVisible = true;
                            });
                          },
                          child: AnimatedScale(
                            scale: _incomeScale,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.income,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.income.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Gelir Ekle',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isExpensePopupVisible)
            ExpensePopup(
              categories: ['Yiyecek', 'Ulaşım', 'Fatura', 'Alışveriş', 'Verilen Borç','Eğlence', 'Diğer'],
              onAdd: (category, amount, description, time) {
                if (_isEditMode) {
                  Transaction updatedTx = Transaction(
                    type: 'expense',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time,
                  );
                  _updateTransaction(updatedTx);
                } else {
                  Transaction newTx = Transaction(
                    type: 'expense',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time,
                  );
                  _saveTransaction(newTx);
                }
                setState(() {
                  _isExpensePopupVisible = false;
                });
              },
              onCancel: () {
                setState(() {
                  _isExpensePopupVisible = false;
                  _isEditMode = false;
                });
              },
              onSubmit: (Transaction tx) {
                if (_isEditMode) {
                  _updateTransaction(tx);
                } else {
                  _saveTransaction(tx);
                }
                setState(() {
                  _isExpensePopupVisible = false;
                  _isEditMode = false;
                });
              },
              initialTransaction: _isEditMode && _transactionToEdit.type == 'expense' ? _transactionToEdit : null,
            ),
          if (_isIncomePopupVisible)
            IncomePopup(
              categories: ['Maaş', 'Burs', 'Harçlık', 'Ek Gelir', 'Alınan Borç', 'Diğer'],
              onAdd: (category, amount, description, time) {
                if (_isEditMode) {
                  Transaction updatedTx = Transaction(
                    type: 'income',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time,
                  );
                  _updateTransaction(updatedTx);
                } else {
                  Transaction newTx = Transaction(
                    type: 'income',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time,
                  );
                  _saveTransaction(newTx);
                }
                setState(() {
                  _isIncomePopupVisible = false;
                });
              },
              onCancel: () {
                setState(() {
                  _isIncomePopupVisible = false;
                  _isEditMode = false;
                });
              },
              onSubmit: (Transaction tx) {
                if (_isEditMode) {
                  _updateTransaction(tx);
                } else {
                  _saveTransaction(tx);
                }
                setState(() {
                  _isIncomePopupVisible = false;
                  _isEditMode = false;
                });
              },
              initialTransaction: _isEditMode && _transactionToEdit.type == 'income' ? _transactionToEdit : null,
            ),
        ],
      ),
    );
  }
}