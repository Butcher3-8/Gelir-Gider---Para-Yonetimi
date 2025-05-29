import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../constants/app_colors.dart';

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
  
  // Kategoriler
  final List<String> _expenseCategories = [
    'Yiyecek', 'Ulaşım', 'Fatura', 'Alışveriş', 
    'Verilen Borç', 'Eğlence', 'Diğer'
  ];
  
  final List<String> _incomeCategories = [
    'Maaş', 'Burs', 'Harçlık', 'Ek Gelir', 'Alınan Borç', 'Diğer'
  ];

  // Seçili ay için kategorik harcamaları hesapla
  Map<String, double> _calculateCategoryExpenses() {
    Map<String, double> categoryExpenses = {};
    
    // Tüm gider kategorilerini 0 ile başlat
    for (String category in _expenseCategories) {
      categoryExpenses[category] = 0.0;
    }
    
    // Seçili ay içindeki gider işlemlerini filtrele
    List<Transaction> monthlyExpenses = widget.transactions.where((transaction) {
      return transaction.type == 'expense' &&
             transaction.dateTime.year == _selectedMonth.year &&
             transaction.dateTime.month == _selectedMonth.month;
    }).toList();
    
    // Kategorilere göre topla
    for (Transaction transaction in monthlyExpenses) {
      if (categoryExpenses.containsKey(transaction.category)) {
        categoryExpenses[transaction.category] = 
            categoryExpenses[transaction.category]! + transaction.amount;
      }
    }
    
    return categoryExpenses;
  }

  // Seçili ay için kategorik gelirleri hesapla
  Map<String, double> _calculateCategoryIncomes() {
    Map<String, double> categoryIncomes = {};
    
    // Tüm gelir kategorilerini 0 ile başlat
    for (String category in _incomeCategories) {
      categoryIncomes[category] = 0.0;
    }
    
    // Seçili ay içindeki gelir işlemlerini filtrele
    List<Transaction> monthlyIncomes = widget.transactions.where((transaction) {
      return transaction.type == 'income' &&
             transaction.dateTime.year == _selectedMonth.year &&
             transaction.dateTime.month == _selectedMonth.month;
    }).toList();
    
    // Kategorilere göre topla
    for (Transaction transaction in monthlyIncomes) {
      if (categoryIncomes.containsKey(transaction.category)) {
        categoryIncomes[transaction.category] = 
            categoryIncomes[transaction.category]! + transaction.amount;
      }
    }
    
    return categoryIncomes;
  }

  // Toplam gider hesapla
  double _calculateTotalExpenses() {
    Map<String, double> expenses = _calculateCategoryExpenses();
    return expenses.values.fold(0.0, (sum, amount) => sum + amount);
  }

  // Toplam gelir hesapla
  double _calculateTotalIncomes() {
    Map<String, double> incomes = _calculateCategoryIncomes();
    return incomes.values.fold(0.0, (sum, amount) => sum + amount);
  }

  // Ay değiştirme fonksiyonları
  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  // Kategori kartı oluştur
  Widget _buildCategoryCard(String category, double amount, bool isExpense) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 0).format(amount)}TL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isExpense ? AppColors.expense : AppColors.income,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryExpenses = _calculateCategoryExpenses();
    Map<String, double> categoryIncomes = _calculateCategoryIncomes();
    double totalExpenses = _calculateTotalExpenses();
    double totalIncomes = _calculateTotalIncomes();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kategori Raporu',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Ay seçici
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                const SizedBox(width: 20),
                Text(
                  DateFormat('MMMM yyyy', 'tr_TR').format(_selectedMonth).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
              ],
            ),
          ),

          // Toplam Kutusu - Tarih altında
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black87, width: 3),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.income,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 0).format(totalIncomes)}TL',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.income,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Toplam Gider',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.expense,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 0).format(totalExpenses)}TL',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.expense,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Net',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 0).format(totalIncomes - totalExpenses)}TL',
                          style: TextStyle(
                            fontSize: 16,
                            color: (totalIncomes - totalExpenses) >= 0 
                                ? AppColors.income 
                                : AppColors.expense,
                            fontWeight: FontWeight.bold,
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
                  // Gider Bölümü
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // Gider Başlığı
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
                        
                        // Gider Kategorileri
                        ...categoryExpenses.entries.map((entry) =>
                            _buildCategoryCard(entry.key, entry.value, true)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Gelir Bölümü
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // Gelir Başlığı
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
                        
                        // Gelir Kategorileri
                        ...categoryIncomes.entries.map((entry) =>
                            _buildCategoryCard(entry.key, entry.value, false)),
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