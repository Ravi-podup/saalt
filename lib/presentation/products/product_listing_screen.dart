import 'package:flutter/material.dart';
import 'package:saalt/helper/cart_store.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/models/shop_category.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/widgets/filter_sheet.dart';
import 'package:saalt/presentation/products/widgets/product_grid_tile.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// A collection listing: two-column grid with absorbency, size and type
/// filters. Opened from a category card or from "View all products".
class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key, this.category});

  static const kCategory = 'category';

  /// [category] null lists the whole catalogue.
  static Future open(BuildContext context, {ShopCategory? category}) {
    return context.push(
      AppRoutePaths.productListingScreen,
      extra: {kCategory: category},
    );
  }

  /// Null lists the whole catalogue.
  final ShopCategory? category;

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _saved = <String>{};
  var _filters = const ProductFilters();

  /// Everything in scope before the filters are applied. The filter options
  /// are derived from this, so a category never offers a size it lacks.
  late final List<Product> _scope = widget.category == null
      ? ProductHelper.catalog
      : ProductHelper.inCategory(widget.category!);

  List<Product> get _visible => _scope
      .where((p) => ProductHelper.offers(p, 'Absorbency', _filters.absorbency))
      .where((p) => ProductHelper.offers(p, 'Size', _filters.sizes))
      .where(
        (p) => _filters.types.isEmpty || _filters.types.contains(p.category),
      )
      .toList();

  void _toast(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  Future<void> _openDetail(Product product) async {
    final added = await ProductDetailScreen.open(context, product: product);
    if (added == null || !mounted) return;
    CartStore.add(added.label, added.quantity);
    _toast('${added.label} added to cart');
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<ProductFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        absorbencies: ProductHelper.optionValues('Absorbency', _scope),
        sizes: ProductHelper.optionValues('Size', _scope),
        types: _scope.map((p) => p.category).toSet().toList(),
        initial: _filters,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _filters = result);
  }

  @override
  Widget build(BuildContext context) {
    final products = _visible;
    final title = widget.category?.label ?? 'All products';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: title,
              subtitle:
                  '${products.length} '
                  '${products.length == 1 ? 'product' : 'products'}',
              onBack: () => context.pop(),
              // Rebuilt on the store, since this screen is one of the places
              // the cart actually grows: add something from a product here
              // and the badge has to move.
              trailing: ValueListenableBuilder<Map<String, int>>(
                valueListenable: CartStore.items,
                builder: (context, _, _) {
                  final count = CartStore.count;
                  return CircleIconButton(
                    icon: count == 0
                        ? Icons.shopping_bag_outlined
                        : Icons.shopping_bag_rounded,
                    badgeCount: count,
                    onTap: () => CartScreen.open(context),
                    tooltip: 'Cart',
                  );
                },
              ),
            ),
            _FilterBar(
              activeCount: _filters.count,
              onOpen: _openFilters,
              onClear: _filters.isEmpty
                  ? null
                  : () => setState(() => _filters = const ProductFilters()),
            ),
            Expanded(
              child: products.isEmpty
                  ? const _NoMatches()
                  : GridView.builder(
                      key: const Key('listing-grid'),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.56,
                          ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductGridTile(
                          product: product,
                          isSaved: _saved.contains(product.name),
                          onTap: () => _openDetail(product),
                          onSaveToggle: () => setState(() {
                            _saved.contains(product.name)
                                ? _saved.remove(product.name)
                                : _saved.add(product.name);
                          }),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.activeCount,
    required this.onOpen,
    this.onClear,
  });

  final int activeCount;
  final VoidCallback onOpen;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final isActive = activeCount > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Row(
        children: [
          Material(
            color: isActive ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: onOpen,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 15,
                      color: isActive ? Colors.white : AppColors.ink,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      isActive ? 'Filters ($activeCount)' : 'Filters',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              behavior: HitTestBehavior.opaque,
              child: const Text(
                'Clear all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.inkMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 34,
              color: AppColors.inkFaint,
            ),
            SizedBox(height: 10),
            Text(
              'Nothing matches those filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
