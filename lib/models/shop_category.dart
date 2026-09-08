/// A browsable shop category. One category can cover several product
/// categories, so "Cups & Discs" is a single card rather than two.
class ShopCategory {
  const ShopCategory({
    required this.label,
    required this.chipLabel,
    required this.imageAsset,
    required this.matches,
  });

  /// Full name, used on the image card.
  final String label;

  /// Shorter name for the filter chip, where width is tight.
  final String chipLabel;

  final String imageAsset;

  /// Product categories this card gathers up.
  final Set<String> matches;
}
