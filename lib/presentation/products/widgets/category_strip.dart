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

  final String? selected;

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
            onTap: () => onSelect(isActive ? null : category.label),
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  /// Leaves the strip's 202 with room for the 9 gap and two lines of label.
  static const _imageHeight = 160.0;

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
              SizedBox(
                height: _imageHeight,
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
              Center(
                child: Text(
                  category.label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
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
