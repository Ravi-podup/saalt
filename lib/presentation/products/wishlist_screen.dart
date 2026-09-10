import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Saved products, laid out as a grid of photographs. You saved these because
/// of how they look, so the picture is the tile and everything else sits
/// under it. Tapping one opens the product, which is where a size gets
/// chosen; the heart is design-only.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.wishlistScreen);
  }

  @override
  Widget build(BuildContext context) {
    final saved = ShopDemo.saved;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Favorites',
              subtitle: '${saved.length} saved',
              onBack: () => context.pop(),
              trailing: CircleIconButton(
                icon: Icons.shopping_bag_outlined,
                tooltip: 'Cart',
                badgeCount: ShopDemo.cartCount,
                onTap: () => CartScreen.open(context),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  const gap = 12.0;
                  const padding = 20.0;
                  final tileWidth =
                      (box.maxWidth - padding * 2 - gap) / 2;

                  return GridView.builder(
                    key: const Key('wishlist-body'),
                    padding: const EdgeInsets.fromLTRB(
                      padding,
                      8,
                      padding,
                      28,
                    ),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: 14,
                          // Sized rather than given a ratio: the square
                          // photograph plus a text block of known height, so
                          // a long product name cannot squeeze the price out.
                          mainAxisExtent: tileWidth + 90,
                        ),
                    itemCount: saved.length,
                    itemBuilder: (context, index) => _SavedTile(
                      product: saved[index],
                      onOpen: () => ProductDetailScreen.open(
                        context,
                        product: saved[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTile extends StatelessWidget {
  const _SavedTile({required this.product, required this.onOpen});

  final Product product;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colours = ProductHelper.colourCount(product);

    return GestureDetector(
      onTap: onOpen,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Photo(product: product),
                const Positioned(top: 8, right: 8, child: _SavedHeart()),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: _RatingPill(rating: product.rating),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Text(
            product.category.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: AppColors.inkFaint,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Text(
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
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                money(product.price),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              if (colours > 1) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$colours colours',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The photograph, with the tinted fallback the rest of the shop uses.
class _Photo extends StatelessWidget {
  const _Photo({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final asset = product.imageAsset;
    final fallback = ColoredBox(
      color: product.tint,
      child: Center(
        child: Icon(product.icon, size: 30, color: product.accent),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: asset == null
          ? fallback
          : Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

/// The heart that says this one is saved. Live to the touch, and stated
/// rather than tracked.
class _SavedHeart extends StatelessWidget {
  const _SavedHeart();

  @override
  Widget build(BuildContext context) {
    // Bordered, not bare white: half these photographs are packshots on a
    // white ground, and an unbordered white disc vanishes into them.
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.hairline),
      ),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: const SizedBox(
          height: 30,
          width: 30,
          child: Icon(Icons.favorite_rounded, size: 15, color: AppColors.rose),
        ),
      ),
    );
  }
}

/// The score, over the photograph's quiet corner.
class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 11, color: AppColors.rose),
          const SizedBox(width: 3),
          Text(
            '$rating',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
