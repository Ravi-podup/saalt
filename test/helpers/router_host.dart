import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_routers.dart';

/// Hosts one screen inside a real router.
///
/// Every screen navigates through `context.push`, which needs a GoRouter
/// above it, so a bare `MaterialApp(home: screen)` throws the moment a test
/// taps something. This puts the screen under test at `/` and hangs the whole
/// app route table off it, so pushes resolve exactly as they do in the app.
Widget hosted(Widget screen, {Key? key}) {
  return MaterialApp.router(
    key: key,
    routerConfig: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => screen),
        ...AppRouters.routes,
      ],
    ),
  );
}
