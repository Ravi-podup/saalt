import 'package:flutter/material.dart';

/// One choice a shopper must make before a product can go in the bag, such as
/// Size or Absorbency.
class ProductOption {
  const ProductOption({required this.name, required this.values});

  final String name;
  final List<String> values;
}

/// A single product in the shop listing.
class Product {
  const Product({
    required this.name,
    required this.blurb,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.icon,
    required this.tint,
    required this.accent,
    this.compareAtPrice,
    this.badge,
    this.imageAsset,
    this.options = const [],
  });

  final String name;
  final String blurb;
  final double price;

  /// Original price, when the item is discounted.
  final double? compareAtPrice;

  /// Out of 5, rendered as half-step stars.
  final double rating;
  final int reviews;
  final String category;

  /// Short marketing flag such as "Bestseller".
  final String? badge;

  /// Real product photography, once it lands in assets. While null the card
  /// falls back to a tinted gradient panel built from [tint] and [icon].
  final String? imageAsset;

  final IconData icon;
  final Color tint;
  final Color accent;

  /// Choices required before this product can be added to the bag. Empty for
  /// single-variant items, which can be quick-added.
  final List<ProductOption> options;

  bool get isDiscounted => compareAtPrice != null && compareAtPrice! > price;

  /// True when the shopper must pick something first.
  bool get needsChoice => options.isNotEmpty;

  /// Matches against a lowercase search term.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        blurb.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q);
  }
}
