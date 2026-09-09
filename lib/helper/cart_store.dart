import 'package:flutter/foundation.dart';

/// The cart, shared across screens. Products are added from a category listing
/// or from search results, but the count is shown on the shop header, so the
/// state cannot live inside one screen.
class CartStore {
  CartStore._();

  /// Resolved variants mapped to quantity, keyed by variant rather than
  /// product name so a Small and a Regular are separate lines.
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
