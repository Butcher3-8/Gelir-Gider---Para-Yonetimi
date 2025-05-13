import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatı için gerekli
import 'package:table_calendar/table_calendar.dart';
import '../core/constants/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/expense_popup.dart';
import '../widgets/income_popup.dart';
import '../widgets/last_transactions.dart';
import '../models/transaction.dart';

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

  final List<Transaction> _transactions = [];

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

  @override
  Widget build(BuildContext context) {
    var transactions = _transactions;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Color.fromRGBO(44, 123, 229, 1),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 80, 78, 78),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: LastTransactions(transactions: transactions),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) => _onTapDown('expense'),
                      onTapUp: (_) => _onTapUp('expense'),
                      onTapCancel: () => _onTapUp('expense'),
                      onTap: () {
                        setState(() {
                          _isExpensePopupVisible = true;
                        });
                      },
                      child: AnimatedScale(
                        scale: _expenseScale,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          height: 80,
                          color: AppColors.expense,
                          alignment: Alignment.center,
                          child: const Text(
                            'Gider Ekle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTapDown: (_) => _onTapDown('income'),
                      onTapUp: (_) => _onTapUp('income'),
                      onTapCancel: () => _onTapUp('income'),
                      onTap: () {
                        setState(() {
                          _isIncomePopupVisible = true;
                        });
                      },
                      child: AnimatedScale(
                        scale: _incomeScale,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          height: 80,
                          color: AppColors.income,
                          alignment: Alignment.center,
                          child: const Text(
                            'Gelir Ekle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isExpensePopupVisible)
            ExpensePopup(
              categories: ['Yiyecek', 'Ulaşım', 'Fatura', 'Diğer'],
              onAdd: (category, amount, description, time) {
                setState(() {
                  _transactions.add(Transaction(
                    type: 'expense',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time, // 'time' DateTime türünde olacak
                  ));
                  _isExpensePopupVisible = false;
                });
              },
              onCancel: () {
                setState(() {
                  _isExpensePopupVisible = false;
                });
              },
            ),
          if (_isIncomePopupVisible)
            IncomePopup(
              categories: ['Maaş', 'Burs', 'Harçlık', 'Ek Gelir', 'Diğer'],
              onAdd: (category, amount, description, time) {
                setState(() {
                  _transactions.add(Transaction(
                    type: 'income',
                    category: category,
                    amount: amount,
                    description: description,
                    dateTime: time, // 'time' DateTime türünde olacak
                  ));
                  _isIncomePopupVisible = false;
                });
              },
              onCancel: () {
                setState(() {
                  _isIncomePopupVisible = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
