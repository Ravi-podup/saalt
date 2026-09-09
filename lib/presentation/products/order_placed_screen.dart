import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/presentation/products/orders_screen.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// The receipt. A static screen: the reference and the dates are stated.
class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.orderPlacedScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                key: const Key('order-placed-body'),
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                children: [
                  Center(
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.successTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 36,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Order placed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A confirmation is on its way to your email, with '
                    'everything you need to track it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ShopCard(
                    children: [
                      _Fact(label: 'Order', value: 'SA-4903'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppColors.hairline, height: 1),
                      ),
                      _Fact(
                        label: 'Arriving',
                        value: ShopDemo.deliveryEstimate,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppColors.hairline, height: 1),
                      ),
                      _Fact(
                        label: 'Deliver to',
                        value:
                            '${ShopDemo.address.name}, '
                            '${ShopDemo.address.line2}',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppColors.hairline, height: 1),
                      ),
                      _Fact(label: 'Paid', value: money(ShopDemo.total)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const ShopSectionLabel('In this order'),
                  ShopCard(
                    children: [
                      for (final line in ShopDemo.cart)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ProductThumb(product: line.product, size: 40),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  '${line.product.name} · ×${line.quantity}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: Column(
                children: [
                  ShopButton(
                    label: 'Track this order',
                    onTap: () => OrdersScreen.open(context),
                  ),
                  const SizedBox(height: 10),
                  ShopOutlineButton(
                    label: 'Keep shopping',
                    // Back to the shop, dropping the checkout pages behind.
                    onTap: () => context.go(AppRoutePaths.productsScreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
              color: AppColors.inkFaint,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
