import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_routers.dart';

void main() {
  final router = AppRouters.createRouter(hasToken: false, isFirstTime: false);
  runApp(MyApp(router: router));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Saalt',
      routerConfig: widget.router,
      theme: ThemeData(
        // Applies Montserrat to the whole text theme, so every Text inherits
        // it and only the weight/size need stating at the call site.
        fontFamily: 'Montserrat',
        // scaffoldBackgroundColor: AppColors.primaryColor,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: SplashScreen(),
    );
  }
}
