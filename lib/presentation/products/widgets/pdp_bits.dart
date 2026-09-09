import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/widgets/shop_bits.dart';
import 'package:saalt/res/app_colors.dart';

/// Small caps label above each block of choices, with the chosen value read
/// back beside it the way the site does it: "COLOR: SOFT SAND".
class PdpLabel extends StatelessWidget {
  const PdpLabel({super.key, required this.text, this.value, this.trailing});

  final String text;

  /// The current selection, spelled out next to the label.
  final String? value;

  /// Optional action on the right, such as a size chart link.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: text.toUpperCase(),
              children: [
                if (value != null)
                  TextSpan(
                    text: ': ${value!.toUpperCase()}',
                    style: const TextStyle(color: AppColors.rose),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.inkFaint,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// The photograph, with the badge and zoom affordances over it and the other
/// shots in a strip below.
class PdpGallery extends StatefulWidget {
  const PdpGallery({super.key, required this.product});

  final Product product;

  @override
  State<PdpGallery> createState() => _PdpGalleryState();
}

class _PdpGalleryState extends State<PdpGallery> {
  final _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _show(int index) {
    // Wraps at both ends so neither arrow is ever a dead control.
    final shots = ProductHelper.galleryFor(widget.product);
    if (shots.isEmpty) return;
    final next = (index + shots.length) % shots.length;
    _pages.animateToPage(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _openZoom(String asset) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _ZoomView(asset: asset, tint: widget.product.tint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final shots = ProductHelper.galleryFor(product);
    final current = _index < shots.length ? shots[_index] : null;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (shots.isEmpty)
                  ColoredBox(color: product.tint)
                else
                  PageView.builder(
                    controller: _pages,
                    itemCount: shots.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) => Image.asset(
                      shots[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => ColoredBox(color: product.tint),
                    ),
                  ),
                if (product.badge != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _Flag(label: product.badge!),
                  ),
                if (current != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: _ZoomPill(onTap: () => _openZoom(current)),
                  ),
                if (shots.length > 1) ...[
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _Arrow(
                        icon: Icons.chevron_left_rounded,
                        label: 'Previous photo',
                        onTap: () => _show(_index - 1),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _Arrow(
                        icon: Icons.chevron_right_rounded,
                        label: 'Next photo',
                        onTap: () => _show(_index + 1),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (shots.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: shots.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _Thumb(
                asset: shots[i],
                tint: product.tint,
                isActive: i == _index,
                onTap: () => _show(i),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.rose,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ZoomPill extends StatelessWidget {
  const _ZoomPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.zoom_in_rounded, size: 13, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'ZOOM',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 32,
            width: 32,
            child: Icon(icon, size: 20, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.asset,
    required this.tint,
    required this.isActive,
    required this.onTap,
  });

  final String asset;
  final Color tint;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.rose : AppColors.hairline,
            width: isActive ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isActive ? 10 : 11),
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => ColoredBox(color: tint),
          ),
        ),
      ),
    );
  }
}

/// Full-bleed pinch-to-zoom view of one photograph.
class _ZoomView extends StatelessWidget {
  const _ZoomView({required this.asset, required this.tint});

  final String asset;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => ColoredBox(color: tint),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _Arrow(
                icon: Icons.close_rounded,
                label: 'Close',
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Headline price, what it was, and how much comes off.
class PdpPriceRow extends StatelessWidget {
  const PdpPriceRow({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final was = product.compareAtPrice;
    final off = product.isDiscounted
        ? (100 * (was! - product.price) / was).round()
        : 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          money(product.price),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
            color: AppColors.ink,
          ),
        ),
        if (product.isDiscounted) ...[
          const SizedBox(width: 9),
          Text(
            money(was!),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.inkFaint,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.rose,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$off% OFF',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Absorbency as pills, each carrying as many drops as the level is worth.
class AbsorbencyPills extends StatelessWidget {
  const AbsorbencyPills({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          _Pill(
            value: value,
            isActive: value == selected,
            onTap: () => onSelect(value),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.value,
    required this.isActive,
    required this.onTap,
  });

  final String value;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final drops = ProductHelper.dropsFor(value);
    final ink = isActive ? Colors.white : AppColors.inkMuted;

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < drops; i++)
                Padding(
                  padding: EdgeInsets.only(right: i == drops - 1 ? 6 : 1),
                  child: Icon(Icons.water_drop_rounded, size: 10, color: ink),
                ),
              Text(
                value.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Colourways as discs of the actual colour.
class SwatchRow extends StatelessWidget {
  const SwatchRow({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final value in values)
          _Swatch(
            name: value,
            isActive: value == selected,
            onTap: () => onSelect(value),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.name,
    required this.isActive,
    required this.onTap,
  });

  final String name;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: name,
      child: Tooltip(
        message: name,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 36,
            width: 36,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // The ring, not a fill, marks the choice — the disc has to keep
              // showing the colour it stands for.
              border: Border.all(
                color: isActive ? AppColors.rose : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ProductHelper.swatchFor(name),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hairline),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sizes as discs, with the chart alongside.
class SizeRow extends StatelessWidget {
  const SizeRow({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelect,
  });

  final List<String> values;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          _SizeDisc(
            label: value,
            isActive: value == selected,
            onTap: () => onSelect(value),
          ),
      ],
    );
  }
}

class _SizeDisc extends StatelessWidget {
  const _SizeDisc({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // A stadium, not a circle: at 42 square the short size labels read as
    // discs anyway, and a long value such as a "Colour/Size" pairing stretches
    // into a pill instead of an ellipse.
    return Material(
      color: isActive ? AppColors.rose : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: isActive ? AppColors.rose : AppColors.hairline,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        // Sized by the label, floored at 42 square. Centre must sit inside the
        // ConstrainedBox with both factors set, or the disc grows to fill the
        // whole row.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : AppColors.inkMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The size chart, as the site publishes it. Reference only — nothing here
/// changes the selection.
class SizeChartSheet extends StatelessWidget {
  const SizeChartSheet({super.key});

  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SizeChartSheet(),
    );
  }

  static const _rows = <({String size, String waist, String hip})>[
    (size: 'XXS', waist: '23–24"', hip: '33–34"'),
    (size: 'XS', waist: '25–26"', hip: '35–36"'),
    (size: 'S', waist: '27–28"', hip: '37–38"'),
    (size: 'M', waist: '29–31"', hip: '39–41"'),
    (size: 'L', waist: '32–34"', hip: '42–44"'),
    (size: 'XL', waist: '35–37"', hip: '45–47"'),
    (size: '2XL', waist: '38–41"', hip: '48–51"'),
    (size: '3XL', waist: '42–45"', hip: '52–55"'),
    (size: '4XL', waist: '46–49"', hip: '56–59"'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Size chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Measure at the narrowest part of your waist and the fullest '
              'part of your hips. Between sizes? Take the larger one.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 16),
            const _ChartRow(
              size: 'SIZE',
              waist: 'WAIST',
              hip: 'HIP',
              isHead: true,
            ),
            for (final row in _rows)
              _ChartRow(size: row.size, waist: row.waist, hip: row.hip),
          ],
        ),
      ),
    );
  }
}

class _ChartRow extends StatelessWidget {
  const _ChartRow({
    required this.size,
    required this.waist,
    required this.hip,
    this.isHead = false,
  });

  final String size;
  final String waist;
  final String hip;
  final bool isHead;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isHead ? 10 : 13,
      fontWeight: isHead ? FontWeight.w700 : FontWeight.w600,
      letterSpacing: isHead ? 0.7 : 0,
      color: isHead ? AppColors.inkFaint : AppColors.ink,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(size, style: style)),
          Expanded(
            flex: 2,
            child: Text(
              waist,
              style: isHead ? style : style.copyWith(color: AppColors.inkMuted),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              hip,
              style: isHead ? style : style.copyWith(color: AppColors.inkMuted),
            ),
          ),
        ],
      ),
    );
  }
}

/// What the shop promises on every order.
class TrustRow extends StatelessWidget {
  const TrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _Promise(
            icon: Icons.verified_user_outlined,
            label: '90-day guarantee',
          ),
        ),
        Expanded(
          child: _Promise(
            icon: Icons.local_shipping_outlined,
            label: 'Free shipping over \$60',
          ),
        ),
      ],
    );
  }
}

class _Promise extends StatelessWidget {
  const _Promise({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.sage),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}

/// One buying option: how many, what comes off, and how it is sold.
class BundleTier {
  const BundleTier({
    required this.quantity,
    required this.discount,
    required this.blurb,
    this.ribbon,
    this.ribbonIsDark = false,
    this.isCustom = false,
  });

  /// Fixed size of the bundle. Ignored for [isCustom], which reads its count
  /// off the stepper.
  final int quantity;

  /// Fraction off the full price, so 0.1 is ten per cent.
  final double discount;

  final String blurb;

  /// Flag across the top corner, such as "MOST POPULAR".
  final String? ribbon;

  /// Best-value ribbons sit in ink; the popular one sits in apricot.
  final bool ribbonIsDark;

  /// The pick-your-own row, which carries a stepper instead of a ribbon.
  final bool isCustom;

  /// Whole-dollar total, which is what the shopper is quoted.
  int totalFor(double unitPrice, int count) =>
      (unitPrice * count * (1 - discount)).round();

  /// Derived from the rounded total rather than the raw one, so the per-unit
  /// figure and the total always agree on screen.
  double perUnitFor(double unitPrice, int count) =>
      totalFor(unitPrice, count) / count;
}

/// The bundle picker: one card per buying option, the chosen one filled in.
class BundleTierCard extends StatelessWidget {
  const BundleTierCard({
    super.key,
    required this.tier,
    required this.product,
    required this.count,
    required this.isActive,
    required this.onSelect,
    required this.onCountChanged,
  });

  final BundleTier tier;
  final Product product;

  /// How many this card is currently offering — the tier size, or whatever
  /// the stepper says on the custom row.
  final int count;

  final bool isActive;
  final VoidCallback onSelect;
  final ValueChanged<int> onCountChanged;

  @override
  Widget build(BuildContext context) {
    final unit = ProductHelper.unitNoun(product);
    final total = tier.totalFor(product.price, count);
    final full = (product.price * count).round();
    final perUnit = tier.perUnitFor(product.price, count);
    final saved = tier.discount > 0 ? (tier.discount * 100).round() : 0;

    return Material(
      color: isActive ? AppColors.apricotTint : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? AppColors.apricot : AppColors.hairline,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              if (tier.ribbon != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: _Ribbon(
                    label: tier.ribbon!,
                    isDark: tier.ribbonIsDark,
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  12,
                  tier.ribbon == null ? 13 : 4,
                  14,
                  13,
                ),
                child: Row(
                  children: [
                    _Radio(isActive: isActive),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.isCustom
                                ? 'Custom quantity'
                                : '$count ${count == 1 ? unit.one : unit.many}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tier.blurb,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              height: 1.3,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          if (saved > 0) ...[
                            const SizedBox(height: 6),
                            _SavePill(percent: saved),
                          ],
                          if (tier.isCustom) ...[
                            const SizedBox(height: 8),
                            QuantityStepper(
                              quantity: count,
                              onLess: () => onCountChanged(
                                count > 1 ? count - 1 : count,
                              ),
                              onMore: () => onCountChanged(
                                count < 9 ? count + 1 : count,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$$total',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: AppColors.ink,
                          ),
                        ),
                        if (saved > 0)
                          Text(
                            '\$$full',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.inkFaint,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          '${money(perUnit)} per ${unit.one}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.inkFaint,
                          ),
                        ),
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

class _Ribbon extends StatelessWidget {
  const _Ribbon({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.ink : AppColors.apricot,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDark ? Icons.local_offer_rounded : Icons.star_rounded,
            size: 10,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.apricot : AppColors.inkFaint,
          width: isActive ? 6 : 1.5,
        ),
      ),
    );
  }
}

class _SavePill extends StatelessWidget {
  const _SavePill({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.successTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Save $percent%',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.success,
        ),
      ),
    );
  }
}
