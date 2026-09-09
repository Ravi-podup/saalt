import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/widgets/pdp_bits.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// What the detail screen hands back when something is added to the cart.
class CartAddition {
  const CartAddition({required this.label, required this.quantity});

  /// Product plus the chosen option values, e.g.
  /// "Leakproof Seamless Brief · Heavy · M · Warm Wheat".
  final String label;

  final int quantity;
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  static const kProduct = 'product';

  /// Resolves to the cart addition the shopper made, or null if they backed
  /// out without adding anything.
  static Future<CartAddition?> open(
    BuildContext context, {
    required Product product,
  }) {
    return context.push<CartAddition>(
      AppRoutePaths.productDetailScreen,
      extra: {kProduct: product},
    );
  }

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /// How the shop sells everything: one to try, a rotation, a full set, or
  /// pick-your-own. The discounts are the ones the site runs.
  static const _tiers = <BundleTier>[
    BundleTier(
      quantity: 1,
      discount: 0,
      blurb: 'Try it out — no commitment',
    ),
    BundleTier(
      quantity: 3,
      discount: 0.10,
      blurb: 'A full rotation',
      ribbon: 'Most popular',
    ),
    BundleTier(
      quantity: 5,
      discount: 0.15,
      blurb: 'Never run out mid-cycle',
      ribbon: 'Best value',
      ribbonIsDark: true,
    ),
    BundleTier(
      quantity: 2,
      discount: 0,
      blurb: 'Pick exactly what you need',
      isCustom: true,
    ),
  ];

  final _chosen = <String, String>{};

  /// Index into [_tiers]. Starts on the rotation, which is the one the shop
  /// pushes and the one carrying the ribbon.
  int _tier = 1;

  /// Count for the custom row only; the fixed tiers carry their own.
  int _customCount = 2;

  @override
  void initState() {
    super.initState();
    // Every option opens on its first value, the way the site arrives with a
    // variant already resolved. Nothing on this screen is ever unanswered,
    // so nothing has to be greyed out.
    for (final option in widget.product.options) {
      final values = ProductHelper.sortValues(option.name, option.values);
      if (values.isNotEmpty) _chosen[option.name] = values.first;
    }
  }

  BundleTier get _selectedTier => _tiers[_tier];

  int _countFor(BundleTier tier) =>
      tier.isCustom ? _customCount : tier.quantity;

  int get _quantity => _countFor(_selectedTier);

  int get _total => _selectedTier.totalFor(widget.product.price, _quantity);

  void _add() {
    final product = widget.product;
    final parts = [
      product.name,
      for (final option in product.options) ?_chosen[option.name],
    ];
    Navigator.of(
      context,
    ).pop(CartAddition(label: parts.join(' · '), quantity: _quantity));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final unit = ProductHelper.unitNoun(product);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // The category reads as the breadcrumb it is; the product name is
            // the headline in the body, where it has room to run to two lines.
            ScreenHeader(title: product.category, onBack: () => context.pop()),
            Expanded(
              child: ListView(
                key: const Key('detail-body'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  PdpGallery(product: product),
                  const SizedBox(height: 18),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 23,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 9),
                  _Ratings(product: product),
                  const SizedBox(height: 14),
                  PdpPriceRow(product: product),
                  const SizedBox(height: 14),
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
                    _OptionBlock(
                      option: option,
                      selected: _chosen[option.name],
                      onSelect: (v) => setState(() => _chosen[option.name] = v),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const _Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'How many ${unit.many}?',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buy more, pay less per ${unit.one}.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < _tiers.length; i++) ...[
                    BundleTierCard(
                      tier: _tiers[i],
                      product: product,
                      count: _countFor(_tiers[i]),
                      isActive: i == _tier,
                      onSelect: () => setState(() => _tier = i),
                      onCountChanged: (c) => setState(() {
                        _customCount = c;
                        // Nudging the stepper is how you pick that row.
                        _tier = i;
                      }),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 8),
                  const TrustRow(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AddBar(
        total: _total,
        summary:
            '$_quantity ${_quantity == 1 ? unit.one : unit.many}'
            '${_chosen['Size'] == null ? '' : ' · ${_chosen['Size']}'}',
        savePercent: (_selectedTier.discount * 100).round(),
        onAdd: _add,
      ),
    );
  }
}

/// Stars, the score, and how many people left one.
class _Ratings extends StatelessWidget {
  const _Ratings({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StarRating(rating: product.rating, size: 14),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '${product.rating} · ${product.reviews} ratings',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
        ),
        if (ProductHelper.colourCount(product) > 1)
          Text(
            '${ProductHelper.colourCount(product)} colours',
            style: const TextStyle(fontSize: 12, color: AppColors.inkFaint),
          ),
      ],
    );
  }
}

/// One choice, drawn the way that choice reads best: swatches for colour,
/// discs for size, drop-counted pills for absorbency.
class _OptionBlock extends StatelessWidget {
  const _OptionBlock({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final ProductOption option;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    // Same canonical order the filters use, so Size reads S, M, L here too.
    final values = ProductHelper.sortValues(option.name, option.values);
    final isColour = option.name == 'Color' && ProductHelper.hasSwatches(values);
    final isSize = option.name == 'Size';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PdpLabel(
          text: option.name,
          value: selected,
          trailing: isSize
              ? _SizeChartLink(onTap: () => SizeChartSheet.open(context))
              : null,
        ),
        const SizedBox(height: 10),
        if (option.name == 'Absorbency')
          AbsorbencyPills(
            values: values,
            selected: selected,
            onSelect: onSelect,
          )
        else if (isColour)
          SwatchRow(values: values, selected: selected, onSelect: onSelect)
        else
          // Discs suit anything short — sizes, and colourways we hold no
          // swatch for, which keep their names.
          SizeRow(values: values, selected: selected, onSelect: onSelect),
      ],
    );
  }
}

class _SizeChartLink extends StatelessWidget {
  const _SizeChartLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          'SIZE CHART',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
            color: AppColors.inkMuted,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AppColors.hairline);
  }
}

/// What is being bought and the button that buys it.
class _AddBar extends StatelessWidget {
  const _AddBar({
    required this.total,
    required this.summary,
    required this.savePercent,
    required this.onAdd,
  });

  final int total;

  /// The selection read back, e.g. "3 pairs · M".
  final String summary;

  final int savePercent;
  final VoidCallback onAdd;

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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.inkFaint,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '\$$total',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: AppColors.ink,
                          ),
                        ),
                        if (savePercent > 0) ...[
                          const SizedBox(width: 7),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successTint,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Save $savePercent%',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _BuyButton(onTap: onAdd),
            ],
          ),
        ),
      ),
    );
  }
}

/// The primary action. Sized to its label rather than the full width, since
/// the order summary sits beside it.
class _BuyButton extends StatelessWidget {
  const _BuyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add to cart',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
