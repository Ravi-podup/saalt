import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/presentation/products/checkout_screen.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// The cart. A static screen: the lines and the totals are stated, and every
/// control is live to the touch without acting.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.cartScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Your cart',
              subtitle: '${ShopDemo.cartCount} items',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('cart-body'),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  for (final line in ShopDemo.cart) ...[
                    _CartRow(line: line),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 4),
                  const _PromoRow(),
                  const SizedBox(height: 18),
                  const ShopSectionLabel('Summary'),
                  ShopCard(
                    children: [
                      MoneyRow(
                        label: 'Subtotal',
                        amount: money(ShopDemo.subtotal),
                      ),
                      MoneyRow(
                        label: 'Shipping',
                        amount: money(ShopDemo.shipping),
                        note: ShopDemo.shipping == 0
                            ? 'Free over ${money(ShopDemo.freeShippingFrom)}'
                            : null,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: AppColors.hairline, height: 1),
                      ),
                      MoneyRow(
                        label: 'Total',
                        amount: money(ShopDemo.total),
                        isTotal: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _Footer(
              total: ShopDemo.total,
              onCheckout: () => CheckoutScreen.open(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    return ShopCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductThumb(product: line.product, size: 66),
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
                          line.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
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
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColors.inkFaint,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    line.variant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkFaint,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      QuantityStepper(quantity: line.quantity),
                      const Spacer(),
                      Text(
                        money(line.lineTotal),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PromoRow extends StatelessWidget {
  const _PromoRow();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.hairline),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_offer_outlined, size: 16, color: AppColors.rose),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Add a promo code',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Icon(
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

class _Footer extends StatelessWidget {
  const _Footer({required this.total, required this.onCheckout});

  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
              const Spacer(),
              Text(
                money(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ShopButton(
            label: 'Checkout',
            icon: Icons.lock_outline_rounded,
            onTap: onCheckout,
          ),
        ],
      ),
    );
  }
}
