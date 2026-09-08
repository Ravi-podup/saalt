import 'package:flutter/material.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/res/app_colors.dart';

/// Best-seller shelf: a section title with inline group tabs, then a
/// horizontal row of image-led cards, matching how the site presents it.
class BestSellers extends StatelessWidget {
  const BestSellers({
    super.key,
    required this.groups,
    required this.selected,
    required this.products,
    required this.onSelectGroup,
    this.onOpen,
  });

  final List<String> groups;
  final String selected;
  final List<Product> products;
  final ValueChanged<String> onSelectGroup;
  final ValueChanged<Product>? onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              const Text(
                'Best Sellers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final group in groups) ...[
                        _GroupTab(
                          label: group,
                          isActive: group == selected,
                          onTap: () => onSelectGroup(group),
                        ),
                        const SizedBox(width: 14),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 320,
          child: ListView.separated(
            key: const Key('best-sellers'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _Card(
              product: products[index],
              onTap: () => onOpen?.call(products[index]),
            ),
          ),
        ),
      ],
    );
  }
}

/// Text tab with the rose underline the site uses, rather than a filled chip.
class _GroupTab extends StatelessWidget {
  const _GroupTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.ink : AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: isActive ? 44 : 0,
              decoration: BoxDecoration(
                color: AppColors.roseTint,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badge = product.absorbencyBadge;
    final asset = product.imageAsset;

    return Semantics(
      button: true,
      label: product.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 176,
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
                        const Positioned(
                          top: 10,
                          right: 10,
                          child: _SalePill(),
                        ),
                      if (badge != null)
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: _AbsorbencyPill(
                            label: badge.label,
                            drops: badge.drops,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
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
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  if (product.isDiscounted) ...[
                    const SizedBox(width: 6),
                    Text(
                      '\$${product.compareAtPrice!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.inkFaint,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          'Sale',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}

/// Droplets plus a label, the way the site signals absorbency at a glance.
class _AbsorbencyPill extends StatelessWidget {
  const _AbsorbencyPill({required this.label, required this.drops});

  final String label;
  final int drops;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < drops; i++)
            const Padding(
              padding: EdgeInsets.only(right: 1),
              child: Icon(
                Icons.water_drop_rounded,
                size: 9,
                color: AppColors.ink,
              ),
            ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
