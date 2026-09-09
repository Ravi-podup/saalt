import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Saved products. A static screen: the list is stated, and the controls are
/// live to the touch without acting.
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
              title: 'Saved',
              subtitle: '${saved.length} items',
              onBack: () => context.pop(),
              trailing: CircleIconButton(
                icon: Icons.shopping_bag_outlined,
                tooltip: 'Cart',
                badgeCount: ShopDemo.cartCount,
                onTap: () => CartScreen.open(context),
              ),
            ),
            Expanded(
              child: ListView.separated(
                key: const Key('wishlist-body'),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                itemCount: saved.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _SavedRow(product: saved[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const _SavedRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ShopCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumb(product: product),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.favorite_rounded,
                              size: 18,
                              color: AppColors.rose,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkFaint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        money(product.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      if (product.isDiscounted) ...[
                        const SizedBox(width: 7),
                        Text(
                          money(product.compareAtPrice!),
                          style: const TextStyle(
                            fontSize: 11.5,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.inkFaint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ShopOutlineButton(
          label: product.needsChoice ? 'Choose a size' : 'Move to cart',
          onTap: () {},
        ),
      ],
    );
  }
}
