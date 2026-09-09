import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Past orders. A static screen: the history is stated.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.ordersScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Your orders',
              subtitle: '${ShopDemo.orders.length} orders',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView.separated(
                key: const Key('orders-body'),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                itemCount: ShopDemo.orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _OrderRow(order: ShopDemo.orders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final DemoOrder order;

  /// What was in it, in words: the first product, then how many others.
  String get _contents {
    final first = order.lines.first.product.name;
    final rest = order.lines.length - 1;
    if (rest == 0) return first;
    return '$first and $rest ${rest == 1 ? 'other' : 'others'}';
  }

  @override
  Widget build(BuildContext context) {
    return ShopCard(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                order.reference,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: AppColors.ink,
                ),
              ),
            ),
            _StatusPill(status: order.status),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final line in order.lines) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ProductThumb(product: line.product, size: 54),
                    if (line.quantity > 1)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          constraints: const BoxConstraints(minWidth: 18),
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.surface,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '×${line.quantity}',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _contents,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Placed ${order.placed} · ${order.items} '
          '${order.items == 1 ? 'item' : 'items'}',
          style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 11),
          child: Divider(color: AppColors.hairline, height: 1),
        ),
        Row(
          children: [
            Text(
              money(order.total),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        'View order',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.rose,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 17,
                        color: AppColors.rose,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (tone, tint, icon) = switch (status) {
      OrderStatus.delivered => (
        AppColors.success,
        AppColors.successTint,
        Icons.check_circle_rounded,
      ),
      OrderStatus.onItsWay => (
        AppColors.periwinkle,
        AppColors.periwinkleTint,
        Icons.local_shipping_outlined,
      ),
      OrderStatus.packing => (
        AppColors.apricot,
        AppColors.apricotTint,
        Icons.inventory_2_outlined,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: tone),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: tone,
            ),
          ),
        ],
      ),
    );
  }
}
