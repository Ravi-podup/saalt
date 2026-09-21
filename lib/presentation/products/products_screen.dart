import 'package:flutter/material.dart';
import 'package:saalt/helper/cart_store.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/presentation/products/product_listing_screen.dart';
import 'package:saalt/presentation/products/wishlist_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/notifications/notifications_screen.dart';
import 'package:saalt/presentation/products/cart_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/widgets/best_sellers.dart';
import 'package:saalt/presentation/products/widgets/category_strip.dart';
import 'package:saalt/presentation/products/widgets/product_card.dart';
import 'package:saalt/presentation/products/widgets/promise_grid.dart';
import 'package:saalt/presentation/products/widgets/recommendation_slider.dart';
import 'package:saalt/presentation/products/widgets/promo_slider.dart';
import 'package:saalt/presentation/products/widgets/social_footer.dart';
import 'package:saalt/presentation/products/widgets/subscribe_card.dart';
import 'package:saalt/presentation/products/widgets/founder_story.dart';
import 'package:saalt/presentation/products/widgets/press_quote.dart';
import 'package:saalt/presentation/products/widgets/why_saalt_wear.dart';
import 'package:saalt/presentation/quiz/fit_quiz_screen.dart';
import 'package:saalt/presentation/products/widgets/products_nav_bar.dart';
import 'package:saalt/presentation/widgets/search_field.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
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
    CartStore.add(added.label, added.quantity);
    _toast('${added.label} added to cart');
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ProductsHeader(
              onBack: () => context.pop(),
              onCart: () => CartScreen.open(context),
              onNotifications: () => NotificationsScreen.open(context),
              onProfile: () => WishlistScreen.open(context),
            ),
            // Full width now that the actions live in the title bar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBox(),
            ),

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
                      child: PromoSlider(images: ProductHelper.banners),
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('Shop by category'),
                    CategoryStrip(
                      categories: ProductHelper.categories,
                      selected: null,
                      onSelect: (label) => _openCategory(label!),
                    ),
                    const SizedBox(height: 26),
                    const BestSellers(),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: WhySaaltWear(
                        imageAsset: ProductHelper.whySaaltWearImage,
                        onShop: () => _openCategory('Leakproof Underwear'),
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Full width, since the band's white ground is the point.
                    const PressQuote(
                      leadIn: '"Saalt period panties are like the ',
                      highlight: 'Lamborghini',
                      tailOff: ' of period underwear."',
                      detail: 'Seamless briefs are made from real materials...',
                    ),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FounderStory(),
                    ),
                    const SizedBox(height: 35),
                    // ReviewCarousel(
                    //   reviews: ProductHelper.reviewQuotes,
                    //   // Read more lands on the full testimonials screen.
                    //   onReadMore: () => TestimonialsScreen.open(context),
                    // ),
                    // const SizedBox(height: 30),
                    const _RecommendationLabel(),
                    const SizedBox(height: 12),
                    const RecommendationSlider(images: recommendationImages),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: PromiseGrid(),
                    ),
                    const SizedBox(height: 26),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SubscribeCard(),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SocialFooter(),
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

/// it: the library on this screen is fixed.
class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 13, color: AppColors.ink),
      cursorColor: AppColors.ink,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Search cups, discs, underwear…',
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkFaint),
        prefixIcon: Image.asset(AppImages.searchIcon, height: 14),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
        border: _border(Color(0xffD9D9D9)),
        enabledBorder: _border(Color(0xffD9D9D9)),
        focusedBorder: _border(Color(0xffD9D9D9)),
      ),
    );
  }

  OutlineInputBorder _border(Color colour) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: colour),
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
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.5,
              color: Color(0xff1C1917),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: Color(0xffD9D9D9), height: 1)),
        ],
      ),
    );
  }
}

/// Back on the left, the section named in the middle, the shop's own actions
/// opposite. Same shape as the Collective, Stories and the Show.
class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({
    this.onBack,
    this.onCart,
    this.onNotifications,
    this.onProfile,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCart;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          BackButtonWidget(onTap: onBack),
          const Expanded(
            child: Text(
              'Products',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.inkDeep,
              ),
            ),
          ),
          // The artwork is the whole button, count and dot included, so these
          // are tapped as images rather than rebuilt as icons.
          _ImageButton(asset: AppImages.cartButtonIcon, onTap: onCart),
          const SizedBox(width: 6),
          _ImageButton(
            asset: AppImages.notificationButtonIcon,
            onTap: onNotifications,
          ),
          const SizedBox(width: 6),
          _ImageButton(
            asset: AppImages.profilePictureCircleImage,
            onTap: onProfile,
          ),
        ],
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton({required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Image.asset(asset, height: 40, width: 40),
    );
  }
}

/// The heading over Cherie's picks: the name, then a rule to the edge.
class _RecommendationLabel extends StatelessWidget {
  const _RecommendationLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "Cherie's Recommendation",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
              color: Color(0xFF1F2A3A),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: Divider(color: Color(0xffD9D9D9), height: 1)),
        ],
      ),
    );
  }
}
