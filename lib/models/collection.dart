/// A promoted collection on the shop landing page.
class Collection {
  const Collection({
    required this.label,
    required this.imageAsset,
    required this.opensCategory,
    this.flag,
    this.discount,
  });

  final String label;
  final String imageAsset;

  final String opensCategory;

  final String? flag;

  final List<String>? discount;
}
