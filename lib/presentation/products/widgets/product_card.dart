import 'package:flutter/material.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/res/app_colors.dart';

/// Editorial product card: imagery on top, then reviews, copy and the buy row.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onChoose,
    this.isSaved = false,
    this.onSaveToggle,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onChoose;
  final bool isSaved;
  final VoidCallback? onSaveToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(
                product: product,
                isSaved: isSaved,
                onSaveToggle: onSaveToggle,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StarRating(rating: product.rating),
                        const SizedBox(width: 7),
                        Text(
                          '${product.reviews} reviews',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.inkFaint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.blurb,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: AppColors.ink,
                          ),
                        ),
                        if (product.isDiscounted) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.compareAtPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: AppColors.inkFaint,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        const Spacer(),
                        // _ChooseButton(
                        //   label: product.needsChoice
                        //       ? 'Choose size'
                        //       : 'Add to cart',
                        //   onTap: onChoose,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Product photography when available, otherwise a tinted panel so the listing
/// still reads as designed rather than broken.
class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
    required this.isSaved,
    this.onSaveToggle,
  });

  final Product product;
  final bool isSaved;
  final VoidCallback? onSaveToggle;

  @override
  Widget build(BuildContext context) {
    final asset = product.imageAsset;

    // Catalogue photography is portrait; a square crop keeps the product
    // centred instead of slicing a thin band out of the middle.
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (asset != null)
            Image.asset(
              asset,
              fit: BoxFit.cover,
              // Photography is dropped in per product; until a file exists the
              // card shows its tinted panel rather than a broken image.
              errorBuilder: (_, _, _) => _TintPanel(product: product),
            )
          else
            _TintPanel(product: product),
          if (product.badge != null)
            Positioned(
              top: 12,
              left: 12,
              child: _Pill(
                label: product.badge!,
                background: AppColors.ink.withValues(alpha: 0.82),
                foreground: Colors.white,
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: _SaveButton(isSaved: isSaved, onTap: onSaveToggle),
          ),
        ],
      ),
    );
  }
}

/// Fallback panel used when a product has no photograph yet.
class _TintPanel extends StatelessWidget {
  const _TintPanel({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [product.tint, Color.lerp(product.tint, Colors.white, 0.55)!],
        ),
      ),
      child: Center(
        child: Icon(
          product.icon,
          size: 58,
          color: product.accent.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
          color: foreground,
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
            height: 34,
            width: 34,
            child: Icon(
              isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 17,
              color: isSaved ? AppColors.rose : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigational, not transactional. Most products have dozens of variants, so
/// the listing cannot add to the cart - it sends you where the choice is made.
class _ChooseButton extends StatelessWidget {
  const _ChooseButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
