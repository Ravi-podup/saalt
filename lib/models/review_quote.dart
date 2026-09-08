/// A pull-quote review for the shop's review carousel.
class ReviewQuote {
  const ReviewQuote({
    required this.product,
    required this.lead,
    required this.emphasis,
    required this.author,
    this.stars = 5,
  });

  /// Which product the review is about.
  final String product;

  /// Opening of the quote, set in regular weight.
  final String lead;

  /// The part worth shouting, set bold. Every one of these quotes builds to
  /// its point, so the split is lead-then-emphasis.
  final String emphasis;

  final String author;
  final int stars;
}
