import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart'; // renk sabitleri için

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      context.go('/home'); // direkt path ile yönlendirme
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // arkaplan rengi
      body: Center(
        child: Lottie.asset(
          'assets/motions/loadingg.json', // Lottie dosyanın yolu
          width: 700, // orta büyüklükte
          height: 700,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
