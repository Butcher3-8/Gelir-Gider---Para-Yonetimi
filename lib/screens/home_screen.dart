import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _expenseScale = 1.0;
  double _incomeScale = 1.0;

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Expanded(child: SizedBox()),

          Row(
            children: [
              // Gider Ekle (Kırmızı)
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) => _onTapDown('expense'),
                  onTapUp: (_) => _onTapUp('expense'),
                  onTapCancel: () => _onTapUp('expense'),
                  onTap: () {
                    // Gider ekleme işlemi
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

              // Gelir Ekle (Yeşil)
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) => _onTapDown('income'),
                  onTapUp: (_) => _onTapUp('income'),
                  onTapCancel: () => _onTapUp('income'),
                  onTap: () {
                    // Gelir ekleme işlemi
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
    );
  }
}
