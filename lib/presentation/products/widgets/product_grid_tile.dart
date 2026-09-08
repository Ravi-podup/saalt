import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/res/app_colors.dart';

/// Compact product tile for a two-column collection grid: image, absorbency
/// badge, colourway count, name, rating and price.
class ProductGridTile extends StatelessWidget {
  const ProductGridTile({
    super.key,
    required this.product,
    this.isSaved = false,
    this.onTap,
    this.onSaveToggle,
  });

  final Product product;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  @override
  Widget build(BuildContext context) {
    final badge = product.absorbencyBadge;
    final colours = ProductHelper.colourCount(product);
    final asset = product.imageAsset;

    return Semantics(
      button: true,
      label: product.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (asset == null)
                      ColoredBox(color: product.tint)
                    else
                      Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            ColoredBox(color: product.tint),
                      ),
                    if (product.isDiscounted)
                      const Positioned(top: 8, left: 8, child: _SalePill()),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _SaveButton(isSaved: isSaved, onTap: onSaveToggle),
                    ),
                    if (badge != null)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: _AbsorbencyPill(
                          label: badge.label,
                          drops: badge.drops,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.25,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                StarRating(rating: product.rating, size: 10),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${product.reviews}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                if (product.isDiscounted) ...[
                  const SizedBox(width: 5),
                  Text(
                    '\$${product.compareAtPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.inkFaint,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
                const Spacer(),
                if (colours > 1)
                  Text(
                    '$colours colours',
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkFaint,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SalePill extends StatelessWidget {
  const _SalePill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.roseTint,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          'Sale',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, this.onTap});

  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isSaved ? 'Remove from saved' : 'Save for later',
      child: Material(
        color: Colors.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 28,
            width: 28,
            child: Icon(
              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 14,
              color: isSaved ? AppColors.rose : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _AbsorbencyPill extends StatelessWidget {
  const _AbsorbencyPill({required this.label, required this.drops});

  final String label;
  final int drops;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < drops; i++)
            const Icon(
              Icons.water_drop_rounded,
              size: 7.5,
              color: AppColors.ink,
            ),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
