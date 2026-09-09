import 'package:flutter/material.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/res/app_colors.dart';

/// Square product thumbnail with the tinted fallback the rest of the shop
/// uses when a photograph will not decode.
class ProductThumb extends StatelessWidget {
  const ProductThumb({super.key, required this.product, this.size = 72});

  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = product.imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: size,
        width: size,
        color: product.tint,
        child: asset == null
            ? Icon(product.icon, size: size * 0.34, color: product.accent)
            : Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  product.icon,
                  size: size * 0.34,
                  color: product.accent,
                ),
              ),
      ),
    );
  }
}

/// White panel the shop screens group rows into.
class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(14),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ShopSectionLabel extends StatelessWidget {
  const ShopSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.inkFaint,
        ),
      ),
    );
  }

  final String text;
}

/// A line of money: label on the left, amount on the right.
class MoneyRow extends StatelessWidget {
  const MoneyRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.note,
  });

  final String label;

  /// Already formatted, so "Free" can sit where a number would.
  final String amount;

  final bool isTotal;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTotal ? 14 : 12.5,
                    fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                    color: isTotal ? AppColors.ink : AppColors.inkMuted,
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    note!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: FontWeight.w700,
              letterSpacing: isTotal ? -0.4 : 0,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width primary action.
class ShopButton extends StatelessWidget {
  const ShopButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary action.
class ShopOutlineButton extends StatelessWidget {
  const ShopOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.ink, width: 1.3),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A choice row: title, detail, and a mark on the selected one. Static — the
/// selection is stated, not tracked.
class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    super.key,
    required this.title,
    required this.detail,
    required this.isSelected,
    required this.onTap,
    this.trailing,
    this.icon,
  });

  final String title;
  final String detail;
  final bool isSelected;
  final VoidCallback onTap;
  final String? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.roseTint : AppColors.canvas,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.rose : AppColors.hairline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.rose : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.rose : AppColors.inkFaint,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              if (icon != null) ...[
                Icon(icon, size: 17, color: AppColors.inkMuted),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
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
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Text(
                  trailing!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Quantity as it reads on a cart line. The buttons are always live to the
/// touch; hand it [onLess]/[onMore] to have them move the number, and leave
/// them off where the count is simply being stated.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    this.onLess,
    this.onMore,
  });

  final int quantity;

  final VoidCallback? onLess;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Step(icon: Icons.remove_rounded, onTap: onLess ?? () {}),
          SizedBox(
            width: 26,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          _Step(icon: Icons.add_rounded, onTap: onMore ?? () {}),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Icon(icon, size: 15, color: AppColors.ink),
        ),
      ),
    );
  }
}

/// Money as the shop writes it.
String money(double amount) => amount == 0
    ? 'Free'
    : '\$${amount == amount.roundToDouble() ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2)}';
