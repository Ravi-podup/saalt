import 'package:flutter/material.dart';
import 'package:saalt/models/shop_category.dart';
import 'package:saalt/res/app_colors.dart';

/// Shop-by-category browser: a cover shot per category with the label
/// beneath, as the site presents it. Image-led rather than text chips, since
/// people recognise the product before they read the word.
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<ShopCategory> categories;

  /// Label of the active category, or null when everything is showing.
  final String? selected;

  /// Passes the label, or null to clear back to everything.
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 202,
      child: ListView.separated(
        key: const Key('shop-categories'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category.label == selected;
          return _Card(
            category: category,
            isActive: isActive,
            // Tapping the active card clears the filter, so there is a way
            // back to everything without a separate "All" card.
            onTap: () => onSelect(isActive ? null : category.label),
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final ShopCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: category.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 138,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        category.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const ColoredBox(color: AppColors.hairline),
                      ),
                      if (isActive)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.ink, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                category.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.25,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  color: isActive ? AppColors.ink : AppColors.inkMuted,
                  decoration: isActive ? TextDecoration.underline : null,
                  decorationColor: AppColors.ink,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
