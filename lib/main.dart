import 'package:flutter/material.dart';
import 'package:saalt/presentation/splash_screen.dart';
import 'package:saalt/res/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saalt',
      theme: ThemeData(
        // scaffoldBackgroundColor: AppColors.primaryColor,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
