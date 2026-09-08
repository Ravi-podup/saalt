import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Single place where every route's page/transition is built.
///
/// Change the returned [Page] here to change the transition app wide.
abstract class AppTransitions {
  static Page<T> buildPage<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return MaterialPage<T>(
      key: state.pageKey,
      name: state.name ?? state.uri.path,
      arguments: state.extra,
      child: child,
    );
  }
}
