import 'package:flutter/material.dart';
import 'package:saalt/helper/bag_store.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/product_listing_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/widgets/best_sellers.dart';
import 'package:saalt/presentation/products/widgets/category_strip.dart';
import 'package:saalt/presentation/products/widgets/collections_row.dart';
import 'package:saalt/presentation/products/widgets/product_card.dart';
import 'package:saalt/presentation/products/widgets/promo_slider.dart';
import 'package:saalt/presentation/products/widgets/review_carousel.dart';
import 'package:saalt/presentation/products/widgets/why_saalt_wear.dart';
import 'package:saalt/presentation/products/widgets/products_nav_bar.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/search_field.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.productsScreen);
  }

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _bestSellerGroup = ProductHelper.bestSellerGroups.keys.first;
  String _query = '';

  /// Hearted products. Saving is a wishlist action, not a purchase.
  final _saved = <String>{};

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openDetail(Product product) async {
    final added = await ProductDetailScreen.open(context, product: product);
    if (added == null || !mounted) return;
    BagStore.add(added.label, added.quantity);
    _toast('${added.label} added to bag');
  }

  /// The landing page browses; the listing only appears as search results.
  List<Product> get _results =>
      ProductHelper.catalog.where((p) => p.matches(_query)).toList();

  void _openCategory(String label) {
    final category = ProductHelper.categories.firstWhere(
      (c) => c.label == label,
    );
    ProductListingScreen.open(context, category: category);
  }

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

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'Products',
              onBack: () => context.pop(),
              // One action group, in the title bar. Splitting four icons
              // across two rows read as clutter.
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    showDot: true,
                    flat: true,
                    onTap: () => _toast('No new notifications'),
                    tooltip: 'Notifications',
                  ),
                  CircleIconButton(
                    icon: _saved.isEmpty
                        ? Icons.favorite_border_rounded
                        : Icons.favorite_rounded,
                    iconColor: _saved.isEmpty ? null : AppColors.rose,
                    badgeCount: _saved.length,
                    flat: true,
                    onTap: () => _toast(
                      _saved.isEmpty
                          ? 'Nothing saved yet'
                          : '${_saved.length} saved',
                    ),
                    tooltip: 'Favourites',
                  ),
                  ValueListenableBuilder<Map<String, int>>(
                    valueListenable: BagStore.items,
                    builder: (context, _, _) {
                      final count = BagStore.count;
                      return CircleIconButton(
                        icon: count == 0
                            ? Icons.shopping_bag_outlined
                            : Icons.shopping_bag_rounded,
                        badgeCount: count,
                        flat: true,
                        onTap: () => _toast(
                          count == 0
                              ? 'Your bag is empty'
                              : '$count in your bag',
                        ),
                        tooltip: 'Bag',
                      );
                    },
                  ),
                ],
              ),
            ),
            // Full width now that the actions live in the title bar.
            SearchField(
              controller: _searchController,
              hintText: 'Search cups, discs, underwear…',
              onChanged: (v) => setState(() => _query = v),
            ),
            // Only the header and search stay put. The banner and the
            // category strip scroll, so the pinned area does not grow.
            Expanded(
              child: ListView(
                key: const Key('shop-body'),
                padding: const EdgeInsets.only(top: 12, bottom: 28),
                children: [
                  // While searching, the banner and the shelf step aside:
                  // results should be results.
                  if (_query.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PromoSlider(
                        images: ProductHelper.banners,
                        onTap: (_) => _toast('Shop the collection'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('Shop by category'),
                    CategoryStrip(
                      categories: ProductHelper.categories,
                      selected: null,
                      onSelect: (label) => _openCategory(label!),
                    ),
                    const SizedBox(height: 26),
                    BestSellers(
                      groups: ProductHelper.bestSellerGroups.keys.toList(),
                      selected: _bestSellerGroup,
                      products: ProductHelper.bestSellers(_bestSellerGroup),
                      onSelectGroup: (g) =>
                          setState(() => _bestSellerGroup = g),
                      onOpen: _openDetail,
                    ),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: WhySaaltWear(
                        imageAsset: ProductHelper.whySaaltWearImage,
                        onShop: () => _openCategory('Leakproof Underwear'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ReviewCarousel(
                      reviews: ProductHelper.reviewQuotes,
                      // Read more lands on the full testimonials screen.
                      onReadMore: () => TestimonialsScreen.open(context),
                    ),
                    const SizedBox(height: 30),
                    const _SectionLabel('Collections'),
                    CollectionsRow(
                      collections: ProductHelper.collections,
                      onOpen: (c) => _openCategory(c.opensCategory),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_query.isNotEmpty) ...[
                    _ResultNote(count: results.length),
                    const SizedBox(height: 10),
                  ],
                  if (_query.isNotEmpty && results.isEmpty)
                    _EmptyState(query: _query)
                  else if (_query.isNotEmpty)
                    for (final product in results) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ProductCard(
                          product: product,
                          isSaved: _saved.contains(product.name),
                          onTap: () => _openDetail(product),
                          onChoose: () => _openDetail(product),
                          onSaveToggle: () => setState(() {
                            _saved.contains(product.name)
                                ? _saved.remove(product.name)
                                : _saved.add(product.name);
                          }),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ProductsNavBar(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: AppColors.inkFaint,
            ),
            const SizedBox(height: 10),
            Text(
              query.isEmpty ? 'Nothing here yet' : 'No products match "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
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

/// Search field with the notification, favourites and profile actions to its
/// right, so the brand bar above stays uncluttered.
/// Compact count shown only while a filter or search is applied.
class _ResultNote extends StatelessWidget {
  const _ResultNote({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      // The body Column centres its children, so stretch to the full width
      // to sit flush with the chips and cards.
      child: SizedBox(
        width: double.infinity,
        child: Text(
          '$count ${count == 1 ? 'product' : 'products'}',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.inkFaint,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
