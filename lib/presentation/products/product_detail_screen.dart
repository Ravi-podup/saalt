import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// What the detail screen hands back when something is added to the bag.
class BagAddition {
  const BagAddition({required this.label, required this.quantity});

  /// Product plus the chosen option values, e.g.
  /// "Leakproof Seamless Brief · Heavy · M · Warm Wheat".
  final String label;

  final int quantity;
}

/// Where the shopper resolves size, absorbency and colour. The listing cannot
/// add to the bag because most products have dozens of variants.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  static const kProduct = 'product';

  /// Resolves to the bag addition the shopper made, or null if they backed
  /// out without adding anything.
  static Future<BagAddition?> open(
    BuildContext context, {
    required Product product,
  }) {
    return context.push<BagAddition>(
      AppRoutePaths.productDetailScreen,
      extra: {kProduct: product},
    );
  }

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _chosen = <String, String>{};
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Preselect any option that only offers one value; there is no decision.
    for (final option in widget.product.options) {
      if (option.values.length == 1) {
        _chosen[option.name] = option.values.single;
      }
    }
  }

  bool get _isComplete =>
      widget.product.options.every((o) => _chosen.containsKey(o.name));

  String? get _firstUnchosen => widget.product.options
      .firstWhere(
        (o) => !_chosen.containsKey(o.name),
        orElse: () => const ProductOption(name: '', values: []),
      )
      .name
      .nullIfEmpty;

  void _add() {
    final product = widget.product;
    final parts = [
      product.name,
      for (final option in product.options) ?_chosen[option.name],
    ];
    Navigator.of(
      context,
    ).pop(BagAddition(label: parts.join(' · '), quantity: _quantity));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: product.name, onBack: () => context.pop()),
            Expanded(
              child: ListView(
                key: const Key('detail-body'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  _Hero(product: product),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      StarRating(rating: product.rating, size: 14),
                      const SizedBox(width: 7),
                      Text(
                        '${product.reviews} reviews',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkFaint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.blurb,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 22),
                  for (final option in product.options) ...[
                    _OptionPicker(
                      option: option,
                      selected: _chosen[option.name],
                      onSelect: (v) => setState(() => _chosen[option.name] = v),
                    ),
                    const SizedBox(height: 18),
                  ],
                  _QuantityStepper(
                    quantity: _quantity,
                    // Steppers belong here, on a resolved variant, not on the
                    // listing where nothing has been chosen yet.
                    onChanged: (q) => setState(() => _quantity = q),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AddBar(
        price: product.price * _quantity,
        isComplete: _isComplete,
        pendingOption: _firstUnchosen,
        onAdd: _isComplete ? _add : null,
      ),
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

class _Hero extends StatelessWidget {
  const _Hero({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final asset = product.imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 1,
        child: asset == null
            ? ColoredBox(color: product.tint)
            : Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(color: product.tint),
              ),
      ),
    );
  }
}

class _OptionPicker extends StatelessWidget {
  const _OptionPicker({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final ProductOption option;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              option.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 6),
            if (selected != null)
              Text(
                selected!,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.inkMuted,
                ),
              )
            else
              const Text(
                'Choose one',
                style: TextStyle(fontSize: 12.5, color: AppColors.rose),
              ),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Same canonical order the filters use, so Size reads S, M, L
            // here as well.
            for (final value in ProductHelper.sortValues(
              option.name,
              option.values,
            ))
              _ValueChip(
                label: value,
                isActive: value == selected,
                onTap: () => onSelect(value),
              ),
          ],
        ),
      ],
    );
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.ink : AppColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isActive ? AppColors.ink : AppColors.hairline,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const Spacer(),
        _StepButton(
          icon: Icons.remove_rounded,
          onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          tooltip: 'Fewer',
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add_rounded,
          onTap: quantity < 9 ? () => onChanged(quantity + 1) : null,
          tooltip: 'More',
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: tooltip,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(side: BorderSide(color: AppColors.hairline)),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 36,
            width: 36,
            child: Icon(
              icon,
              size: 17,
              color: enabled ? AppColors.ink : AppColors.inkFaint,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddBar extends StatelessWidget {
  const _AddBar({
    required this.price,
    required this.isComplete,
    required this.pendingOption,
    this.onAdd,
  });

  final double price;
  final bool isComplete;
  final String? pendingOption;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Material(
                  color: isComplete ? AppColors.ink : AppColors.hairline,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: onAdd,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        isComplete
                            ? 'Add to bag'
                            : 'Choose ${pendingOption!.toLowerCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: isComplete ? Colors.white : AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
