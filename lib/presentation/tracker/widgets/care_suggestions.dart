import 'package:flutter/material.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/res/app_colors.dart';

/// What Saalt makes for the day on screen. Shown only when the day calls for
/// something, so it reads as help rather than an advert.
class CareSuggestions extends StatelessWidget {
  const CareSuggestions({
    super.key,
    required this.products,
    required this.reason,
  });

  final List<Product> products;

  /// Why these, in the user's own terms: "For a heavy day".
  final String reason;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  size: 13,
                  color: AppColors.rose,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < products.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.only(left: 72),
                child: Divider(color: AppColors.hairline, height: 1),
              ),
            _SuggestionRow(product: products[i]),
          ],
        ],
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.product});

  final Product product;

  void _open(BuildContext context) {
    ProductDetailScreen.open(context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 12),
          child: Row(
            children: [
              _Thumb(product: product),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: AppColors.inkFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final asset = product.imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        width: 44,
        color: product.tint,
        child: asset == null
            ? Icon(product.icon, size: 20, color: product.accent)
            : Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(product.icon, size: 20, color: product.accent),
              ),
      ),
    );
  }
}
