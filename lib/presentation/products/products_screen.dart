import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/widgets/product_card.dart';
import 'package:saalt/presentation/products/widgets/promo_slider.dart';
import 'package:saalt/presentation/products/widgets/products_nav_bar.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/search_field.dart';
import 'package:saalt/res/app_colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const _categories = ['All', 'Cups', 'Discs', 'Underwear', 'Bundles'];

  String _selected = 'All';
  String _query = '';

  /// Hearted products. Saving is a wishlist action, not a purchase.
  final _saved = <String>{};

  /// Resolved variants in the bag, mapped to quantity. Keyed by variant rather
  /// than product name so a Small and a Regular are separate lines.
  final _bag = <String, int>{};
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// True when the list is showing less than the whole catalogue, which is
  /// the only time a count tells the reader anything.
  /// Total items, not distinct lines: two of one variant counts as two.
  int get _bagCount => _bag.values.fold(0, (sum, q) => sum + q);

  /// Sends the shopper to where size, absorbency and colour get resolved, then
  /// folds whatever they chose into the bag.
  Future<void> _openDetail(Product product) async {
    final added = await Navigator.of(context).push<BagAddition>(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
    if (added == null || !mounted) return;
    setState(() {
      _bag.update(
        added.label,
        (q) => q + added.quantity,
        ifAbsent: () => added.quantity,
      );
    });
    _toast('${added.label} added to bag');
  }

  bool get _isNarrowed => _selected != 'All' || _query.isNotEmpty;

  List<Product> get _visible => ProductHelper.catalog
      .where((p) => _selected == 'All' || p.category == _selected)
      .where((p) => p.matches(_query))
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

  @override
  Widget build(BuildContext context) {
    final products = _visible;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'Products',
              onBack: () => Navigator.of(context).maybePop(),
              trailing: CircleIconButton(
                icon: _bagCount == 0
                    ? Icons.shopping_bag_outlined
                    : Icons.shopping_bag_rounded,
                badgeCount: _bagCount,
                onTap: () => _toast(
                  _bagCount == 0
                      ? 'Your bag is empty'
                      : '$_bagCount in your bag',
                ),
                tooltip: 'Bag',
              ),
            ),
            _SearchRow(
              controller: _searchController,
              savedCount: _saved.length,
              onChanged: (v) => setState(() => _query = v),
              onNotifications: () => _toast('No new notifications'),
              onFavourites: () => _toast(
                _saved.isEmpty ? 'Nothing saved yet' : '${_saved.length} saved',
              ),
              onProfile: () => _toast('Profile'),
            ),
            // Only the header and search stay put. The banner and the
            // category strip scroll, so the pinned area does not grow.
            Expanded(
              child: ListView(
                key: const Key('shop-body'),
                padding: const EdgeInsets.only(top: 12, bottom: 28),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PromoSlider(
                      images: ProductHelper.banners,
                      onTap: (_) => _toast('Shop the collection'),
                    ),
                  ),
                  _FilterBar(
                    categories: _categories,
                    selected: _selected,
                    onSelect: (c) => setState(() => _selected = c),
                  ),
                  if (_isNarrowed) _ResultNote(count: products.length),
                  const SizedBox(height: 10),
                  if (products.isEmpty)
                    _EmptyState(query: _query)
                  else
                    for (final product in products) ...[
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
class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.savedCount,
    required this.onChanged,
    this.onNotifications,
    this.onFavourites,
    this.onProfile,
  });

  final TextEditingController controller;
  final int savedCount;
  final ValueChanged<String> onChanged;
  final VoidCallback? onNotifications;
  final VoidCallback? onFavourites;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              controller: controller,
              hintText: 'Search products…',
              onChanged: onChanged,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 4),
          CircleIconButton(
            icon: Icons.notifications_none_rounded,
            showDot: true,
            flat: true,
            onTap: onNotifications,
            tooltip: 'Notifications',
          ),
          CircleIconButton(
            icon: savedCount == 0
                ? Icons.favorite_border_rounded
                : Icons.favorite_rounded,
            // Rose when active: a filled heart in ink reads as a black blob.
            iconColor: savedCount == 0 ? null : AppColors.rose,
            badgeCount: savedCount,
            flat: true,
            onTap: onFavourites,
            tooltip: 'Favourites',
          ),
          CircleIconButton(
            icon: Icons.person_outline_rounded,
            flat: true,
            onTap: onProfile,
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}

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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        key: const Key('product-categories'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category == selected;
          return Material(
            color: isActive ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => onSelect(category),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.inkMuted,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
