import 'package:flutter/foundation.dart';

class CartStore {
  CartStore._();

  static final items = ValueNotifier<Map<String, int>>({});

  /// Total items, not distinct lines: two of one variant counts as two.
  static int get count => items.value.values.fold(0, (sum, q) => sum + q);

  static void add(String label, int quantity) {
    final next = Map<String, int>.of(items.value);
    next.update(label, (q) => q + quantity, ifAbsent: () => quantity);
    items.value = next;
  }

  @visibleForTesting
  static void clear() => items.value = {};
}
