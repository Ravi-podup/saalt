import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/presentation/products/order_placed_screen.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Checkout. A static screen: the address, the chosen shipping and the chosen
/// payment method are stated, and the controls are live without acting.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.checkoutScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Checkout',
              subtitle:
                  '${ShopDemo.cartCount} items · ${money(ShopDemo.total)}',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('checkout-body'),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  const ShopSectionLabel('Deliver to'),
                  ShopCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 17,
                            color: AppColors.rose,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ShopDemo.address.name,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${ShopDemo.address.line1}\n'
                                  '${ShopDemo.address.line2}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    height: 1.5,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _Link(label: 'Change', onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const ShopSectionLabel('Shipping'),
                  ChoiceRow(
                    title: 'Standard',
                    detail: ShopDemo.deliveryEstimate,
                    trailing: 'Free',
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ChoiceRow(
                    title: 'Express',
                    detail: 'Wed 10 Sep',
                    trailing: money(9.95),
                    isSelected: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),
                  const ShopSectionLabel('Payment'),
                  ChoiceRow(
                    title: 'Card ending 4242',
                    detail: 'Visa · expires 04/28',
                    icon: Icons.credit_card_rounded,
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ChoiceRow(
                    title: 'UPI',
                    detail: 'Pay from any UPI app',
                    icon: Icons.account_balance_rounded,
                    isSelected: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ChoiceRow(
                    title: 'Cash on delivery',
                    detail: 'Pay the courier',
                    icon: Icons.payments_outlined,
                    isSelected: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),
                  const ShopSectionLabel('Order summary'),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${line.variant} · ×${line.quantity}',
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
                                money(line.lineTotal),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(color: AppColors.hairline, height: 1),
                      const SizedBox(height: 6),
                      MoneyRow(
                        label: 'Subtotal',
                        amount: money(ShopDemo.subtotal),
                      ),
                      MoneyRow(
                        label: 'Shipping',
                        amount: money(ShopDemo.shipping),
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
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: ShopButton(
                label: 'Place order · ${money(ShopDemo.total)}',
                onTap: () => OrderPlacedScreen.open(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.rose,
            ),
          ),
        ),
      ),
    );
  }
}
