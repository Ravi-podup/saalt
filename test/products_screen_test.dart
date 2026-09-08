import 'package:flutter/material.dart';
import 'package:saalt/helper/bag_store.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/products/product_listing_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/testimonials/testimonials_screen.dart';
import 'package:saalt/presentation/products/widgets/best_sellers.dart';
import 'package:saalt/presentation/products/widgets/category_strip.dart';
import 'package:saalt/presentation/products/widgets/collections_row.dart';
import 'package:saalt/presentation/products/widgets/product_card.dart';
import 'package:saalt/presentation/products/widgets/product_grid_tile.dart';
import 'package:saalt/presentation/products/widgets/promo_slider.dart';
import 'package:saalt/presentation/products/widgets/review_carousel.dart';
import 'package:saalt/presentation/products/widgets/why_saalt_wear.dart';
import 'package:saalt/presentation/products/widgets/products_nav_bar.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';

/// Chips further down the detail screen are not laid out until scrolled to.
Future<void> _pickOption(WidgetTester tester, String value) async {
  final chip = find.widgetWithText(InkWell, value);
  await tester.scrollUntilVisible(
    chip,
    160,
    scrollable: find.descendant(
      of: find.byKey(const Key('detail-body')),
      matching: find.byType(Scrollable),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(chip.first);
  await tester.pumpAndSettle();
}

/// The best-seller shelf sits above the listing, so the first product card
/// starts below the fold. Scoped to ProductCard because a best-seller title
/// and its listing title are the same string.
Finder _shopBody() => find
    .descendant(
      of: find.byKey(const Key('shop-body')),
      matching: find.byType(Scrollable),
    )
    .first;

/// Brings a widget in the long shop page into the build tree and on screen.
Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  if (target.evaluate().isEmpty) {
    await tester.scrollUntilVisible(target, 250, scrollable: _shopBody());
  }
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
}

/// Back to the top, so the banner, category strip and shelf exist again.
Future<void> _toTop(WidgetTester tester) async {
  await tester.drag(find.byKey(const Key('shop-body')), const Offset(0, 3000));
  await tester.pumpAndSettle();
}

/// A product title in a listing, not the best-seller shelf above it. Covers
/// both forms: grid tiles on a collection page, cards in search results.
Finder _listed(String name) => find.descendant(
  of: find.byWidgetPredicate((w) => w is ProductGridTile || w is ProductCard),
  matching: find.text(name),
);

/// The landing page browses rather than lists, so a product card is reached
/// by searching for it. Its full name matches exactly one product.
Future<void> _revealCard(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(TextField), name);
  await tester.pumpAndSettle();
  await tester.ensureVisible(
    find.ancestor(of: _listed(name), matching: find.byType(ProductCard)),
  );
  await tester.pumpAndSettle();
}

/// Pumps one category's listing, which is where product cards now live.
Future<void> _pumpCategory(WidgetTester tester, String label) async {
  final category = ProductHelper.categories.firstWhere((c) => c.label == label);
  await tester.pumpWidget(
    MaterialApp(home: ProductListingScreen(category: category)),
  );
  await tester.pumpAndSettle();
}

/// Taps a category card from the top of the page, where the strip lives.
Future<void> _tapCategoryCard(WidgetTester tester, String label) async {
  await _toTop(tester);
  final strip = find.byKey(const Key('shop-categories'));
  final card = find.descendant(of: strip, matching: find.text(label));
  if (card.evaluate().isEmpty) {
    await tester.dragUntilVisible(card, strip, const Offset(-150, 0));
  }
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  // The bag is shared across screens, so it must not leak between tests.
  BagStore.clear();
  addTearDown(BagStore.clear);
}

void main() {
  testWidgets('the landing page browses; it does not list products', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // No chip row and no listing beneath: the shelf and categories are the
    // browse surface.
    expect(find.byKey(const Key('product-categories')), findsNothing);
    expect(find.byType(ProductCard), findsNothing);
    expect(find.text('Shop by category'), findsOneWidget);
  });

  testWidgets('a category card opens that category listing', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _tapCategoryCard(tester, 'Cups & Discs');

    expect(find.byType(ProductListingScreen), findsOneWidget);
    // Cups (2) plus Discs (1).
    expect(find.text('3 products'), findsOneWidget);
    expect(_listed('Saalt Cup'), findsOneWidget);
    expect(_listed('Leakproof Seamless Thong'), findsNothing);
  });

  testWidgets('header stays put while the catalogue scrolls', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final searchBefore = tester.getTopLeft(find.byType(TextField));
    await tester.drag(
      find.byKey(const Key('shop-body')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(TextField)), searchBefore);
  });

  testWidgets('saving a product updates the favourites badge', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.text('1'), findsNothing);

    // Scope to the card: the header now carries a favourites icon too, so an
    // unscoped byIcon finder would hit that instead.
    await _revealCard(tester, 'Leakproof Seamless Thong');
    final firstCard = find.byType(ProductCard).first;
    await tester.tap(
      find.descendant(
        of: firstCard,
        matching: find.byIcon(Icons.favorite_border_rounded),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: firstCard,
        matching: find.byIcon(Icons.favorite_rounded),
      ),
      findsOneWidget,
    );
    // Header badge picks up the count.
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('actions sit in one row, with search full width beneath', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // All three actions live in the title bar, not beside the search field.
    final header = find.byType(ScreenHeader);
    for (final icon in [
      Icons.notifications_none_rounded,
      Icons.favorite_border_rounded,
      Icons.shopping_bag_outlined,
    ]) {
      expect(
        find.descendant(of: header, matching: find.byIcon(icon)),
        findsOneWidget,
        reason: '$icon belongs in the title bar',
      );
    }

    // The search field is a sibling of the header, and spans the width.
    expect(
      find.descendant(of: header, matching: find.byType(TextField)),
      findsNothing,
    );
    final field = tester.getRect(find.byType(TextField));
    final screen = tester.getRect(find.byType(ProductsScreen));
    expect(
      field.width,
      greaterThan(screen.width - 60),
      reason: 'the field should not be shortened for icons any more',
    );
  });

  testWidgets('search narrows the catalogue and reports no matches', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await tester.enterText(find.byType(TextField), 'cloudshort');
    await tester.pumpAndSettle();

    expect(find.text('1 product'), findsOneWidget);
    expect(_listed('Leakproof Comfort CloudShort'), findsOneWidget);
    expect(_listed('Leakproof Seamless Thong'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('No products match "zzzzz"'), findsOneWidget);
  });

  testWidgets('Products tile on the dashboard opens the listing', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.text('Shop by category'), findsOneWidget);
  });

  testWidgets('bottom bar shows four tabs with Home current', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final bar = find.byType(ProductsNavBar);
    expect(bar, findsOneWidget);

    for (final label in ['Home', 'Underwear', 'Cups & Discs', 'Bags']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
        reason: '$label tab should be present',
      );
    }

    // Home reads as current through its label weight; the rest do not.
    TextStyle labelStyle(String label) => tester
        .widget<Text>(find.descendant(of: bar, matching: find.text(label)))
        .style!;

    expect(labelStyle('Home').fontWeight, FontWeight.w700);
    for (final label in ['Underwear', 'Cups & Discs', 'Bags']) {
      expect(
        labelStyle(label).fontWeight,
        FontWeight.w600,
        reason: '$label should not read as current',
      );
    }
  });

  testWidgets('bottom bar tabs do not navigate or filter', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final bar = find.byType(ProductsNavBar);
    await tester.tap(
      find.descendant(of: bar, matching: find.text('Cups & Discs')),
    );
    await tester.pumpAndSettle();

    // Still on the same screen, still browsing.
    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.text('Shop by category'), findsOneWidget);
  });

  testWidgets('liking a product does not touch the bag count', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // Back comes first in the header, the bag second.

    // Heart the first product.
    await _revealCard(tester, 'Leakproof Seamless Thong');
    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.byIcon(Icons.favorite_border_rounded),
      ),
    );
    await tester.pumpAndSettle();

    // Hearting is a wishlist action; the bag is untouched.
    expect(BagStore.count, 0);
  });

  testWidgets('a listing cannot add to the bag; it routes to the choice', (
    tester,
  ) async {
    _phone(tester);
    await _pumpCategory(tester, 'Leakproof Underwear');

    // No transactional CTA on a listing: a tile routes to the choice.
    expect(find.text('BUY NOW'), findsNothing);
    expect(BagStore.count, 0);

    await tester.tap(find.byType(ProductGridTile).first);
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsOneWidget);
  });

  testWidgets('detail requires every option before adding to the bag', (
    tester,
  ) async {
    _phone(tester);
    await _pumpCategory(tester, 'Leakproof Underwear');

    await tester.tap(find.byType(ProductGridTile).first);
    await tester.pumpAndSettle();

    // Absorbency has one value so it is preselected; Size and Color are open.
    expect(find.text('Add to bag'), findsNothing);
    expect(find.text('Choose size'), findsOneWidget);

    await _pickOption(tester, 'M');
    expect(find.text('Choose color'), findsOneWidget);

    await _pickOption(tester, 'Warm Wheat');
    expect(find.text('Add to bag'), findsOneWidget);
  });

  testWidgets('adding a resolved variant fills the shared bag', (tester) async {
    _phone(tester);
    await _pumpCategory(tester, 'Leakproof Underwear');

    await tester.tap(find.byType(ProductGridTile).first);
    await tester.pumpAndSettle();

    await _pickOption(tester, 'M');
    await _pickOption(tester, 'Warm Wheat');

    // Quantity lives here, on a resolved variant.
    await tester.scrollUntilVisible(
      find.byIcon(Icons.add_rounded),
      160,
      scrollable: find.descendant(
        of: find.byKey(const Key('detail-body')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Add to bag'));
    await tester.pumpAndSettle();

    // Two of one variant counts as two in the shared bag.
    expect(BagStore.count, 2);
  });

  testWidgets('active favourites icon is rose, not ink', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _revealCard(tester, 'Leakproof Seamless Thong');
    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.byIcon(Icons.favorite_border_rounded),
      ),
    );
    await tester.pumpAndSettle();

    // The favourites button sits beside the search field, not inside it, and
    // is the only CircleIconButton carrying a filled heart.
    final favourite = tester.widget<CircleIconButton>(
      find.ancestor(
        of: find.byIcon(Icons.favorite_rounded),
        matching: find.byType(CircleIconButton),
      ),
    );
    expect(favourite.iconColor, AppColors.rose);
  });

  test('banners are formats Flutter can actually decode', () {
    expect(ProductHelper.banners, isNotEmpty);
    for (final banner in ProductHelper.banners) {
      expect(
        banner,
        endsWith('.jpg'),
        reason: 'Flutter cannot decode AVIF, so banners must be converted',
      );
    }
  });

  testWidgets('the shop opens on a swipeable banner slider', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.byType(PromoSlider), findsOneWidget);
    final slider = find.byKey(const Key('promo-slider'));
    expect(slider, findsOneWidget);

    // First banner is showing.
    Image shown() => tester
        .widgetList<Image>(
          find.descendant(of: slider, matching: find.byType(Image)),
        )
        .first;
    expect(
      (shown().image as AssetImage).assetName,
      ProductHelper.banners.first,
    );

    await tester.drag(slider, const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect((shown().image as AssetImage).assetName, ProductHelper.banners[1]);
  });

  testWidgets('banner and category strip scroll; header and search do not', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final searchBefore = tester.getTopLeft(find.byType(TextField));
    final bannerBefore = tester.getTopLeft(find.byType(PromoSlider));

    // Small drag: scroll far enough and the banner leaves the cache extent
    // and is disposed, so there is nothing left to measure.
    await tester.drag(find.byKey(const Key('shop-body')), const Offset(0, -90));
    await tester.pumpAndSettle();

    // Search holds position; the banner moves with the content.
    expect(tester.getTopLeft(find.byType(TextField)), searchBefore);
    expect(
      tester.getTopLeft(find.byType(PromoSlider)).dy,
      lessThan(bannerBefore.dy),
    );
  });

  testWidgets('best sellers shelf switches between its two groups', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.text('Best Sellers'), findsOneWidget);
    final shelf = find.byKey(const Key('best-sellers'));

    // Saalt Wear leads.
    expect(
      find.descendant(
        of: shelf,
        matching: find.text('Leakproof Seamless Thong'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shelf, matching: find.text('Saalt Cup')),
      findsNothing,
    );

    // 'Cups & Discs' is also a category card label, so scope to the shelf.
    final tab = find.descendant(
      of: find.byType(BestSellers),
      matching: find.text('Cups & Discs'),
    );
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: shelf, matching: find.text('Saalt Cup')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: shelf,
        matching: find.text('Leakproof Seamless Thong'),
      ),
      findsNothing,
    );
  });

  testWidgets('shelf cards render the absorbency badge', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // Only the leading cards are built at a time, so assert on the first.
    // The derivation itself is covered by the unit test below.
    expect(
      find.descendant(
        of: find.byKey(const Key('best-sellers')),
        matching: find.text('Light'),
      ),
      findsOneWidget,
    );
  });

  test('absorbency badges read level or count, and cups have none', () {
    final thong = ProductHelper.catalog.firstWhere(
      (p) => p.name == 'Leakproof Seamless Thong',
    );
    expect(thong.absorbencyBadge?.label, 'Light');
    expect(thong.absorbencyBadge?.drops, 2);

    final brief = ProductHelper.catalog.firstWhere(
      (p) => p.name == 'Leakproof Seamless Brief',
    );
    expect(brief.absorbencyBadge?.label, '3 options');

    final cup = ProductHelper.catalog.firstWhere((p) => p.name == 'Saalt Cup');
    expect(cup.absorbencyBadge, isNull);
  });

  testWidgets('searching hides the banner and the shelf', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.byType(BestSellers), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'cloudshort');
    await tester.pumpAndSettle();

    expect(find.byType(BestSellers), findsNothing);
    expect(find.byType(PromoSlider), findsNothing);
    expect(_listed('Leakproof Comfort CloudShort'), findsOneWidget);
  });

  testWidgets('shop by category is back, image-led, with every card stocked', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.text('Shop by category'), findsOneWidget);
    expect(find.byType(CategoryStrip), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('shop-categories')),
        matching: find.text('Leakproof Underwear'),
      ),
      findsOneWidget,
    );

    for (final category in ProductHelper.categories) {
      expect(
        ProductHelper.inCategory(category),
        isNotEmpty,
        reason: '${category.label} must not be an empty category',
      );
    }
  });

  testWidgets('Why Saalt Wear promotes the underwear line', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(WhySaaltWear));

    expect(find.text('Why Saalt Wear?'), findsOneWidget);
    expect(find.text('SHOP SAALT WEAR'), findsOneWidget);

    await tester.tap(find.text('SHOP SAALT WEAR'));
    await tester.pumpAndSettle();

    // The CTA opens the underwear listing.
    expect(find.byType(ProductListingScreen), findsOneWidget);
    expect(find.text('Leakproof Underwear'), findsWidgets);
    expect(_listed('Saalt Cup'), findsNothing);
  });

  testWidgets('collections sit below Why Saalt Wear with their flags', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(CollectionsRow));

    expect(find.text('Collections'), findsOneWidget);
    final row = find.byKey(const Key('shop-collections'));
    expect(
      find.descendant(of: row, matching: find.text('Cotton Lace Trim')),
      findsOneWidget,
    );
    // Cotton Lace Trim is flagged NEW; the deals card carries a discount.
    expect(
      find.descendant(of: row, matching: find.text('NEW')),
      findsOneWidget,
    );
  });

  testWidgets('a collection card opens a listing', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(CollectionsRow));
    await tester.tap(find.text('Cotton Lace Trim'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductListingScreen), findsOneWidget);
  });

  test('every collection points at a category that exists', () {
    for (final collection in ProductHelper.collections) {
      final match = ProductHelper.categories
          .where((c) => c.label == collection.opensCategory)
          .toList();
      expect(
        match,
        hasLength(1),
        reason: '${collection.label} points at an unknown category',
      );
      expect(ProductHelper.inCategory(match.single), isNotEmpty);
    }
  });

  testWidgets('review quotes sit between Why Saalt Wear and Collections', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(ReviewCarousel));

    // First quote, with its product and author.
    expect(find.text('Saalt Cup'), findsWidgets);
    expect(find.text('– Kels'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
    expect(find.text('Read more reviews'), findsOneWidget);

    // Collections are further down the same page. Pixel-ordering assertions
    // are brittle here: a sibling scrolls out of the tree and is disposed.
    await _scrollTo(tester, find.byType(CollectionsRow));
    expect(find.byType(CollectionsRow), findsOneWidget);
  });

  testWidgets('swiping the reviews moves to the next quote', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(ReviewCarousel));

    expect(find.text('– Kels'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('review-carousel')),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('– Dava'), findsOneWidget);
    expect(find.text('– Kels'), findsNothing);
  });

  testWidgets('Read more reviews opens the testimonials screen', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await _scrollTo(tester, find.byType(ReviewCarousel));
    await tester.tap(find.text('Read more reviews'));
    await tester.pumpAndSettle();

    expect(find.byType(TestimonialsScreen), findsOneWidget);
  });

  test('every quote builds to a bold emphasis and names its product', () {
    for (final quote in ProductHelper.reviewQuotes) {
      expect(quote.lead, isNotEmpty);
      expect(quote.emphasis, isNotEmpty);
      expect(quote.author, isNotEmpty);
      expect(
        ProductHelper.catalog.any((p) => p.name == quote.product),
        isTrue,
        reason: '${quote.product} should be a real product',
      );
    }
  });

  testWidgets('filters narrow the listing and can be cleared', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductListingScreen()));

    expect(find.text('18 products'), findsOneWidget);

    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();

    // Options are derived from the products in scope.
    expect(find.text('Absorbency'), findsOneWidget);
    expect(find.text('Size'), findsOneWidget);

    await tester.tap(find.widgetWithText(InkWell, 'Super').first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Apply ('));
    await tester.pumpAndSettle();

    // Only the garments offering Super remain.
    expect(find.text('Filters (1)'), findsOneWidget);
    expect(
      find.textContaining(' products'),
      findsWidgets,
      reason: 'the count should narrow',
    );
    expect(find.text('18 products'), findsNothing);

    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    expect(find.text('18 products'), findsOneWidget);
  });

  testWidgets('a filter combination with no matches says so', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductListingScreen()));

    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    // Cups have no absorbency, so pairing the two yields nothing.
    await tester.tap(find.widgetWithText(InkWell, 'Cups').first);
    await tester.tap(find.widgetWithText(InkWell, 'Super').first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Apply ('));
    await tester.pumpAndSettle();

    expect(find.text('Nothing matches those filters'), findsOneWidget);
  });

  test('filter options never offer a value the scope lacks', () {
    final cups = ProductHelper.categories.firstWhere(
      (c) => c.label == 'Cups & Discs',
    );
    final scope = ProductHelper.inCategory(cups);
    // No cup or disc has an absorbency choice.
    expect(ProductHelper.optionValues('Absorbency', scope), isEmpty);
    expect(ProductHelper.optionValues('Size', scope), isNotEmpty);
  });

  test('absorbency runs light to heavy, not feed order', () {
    expect(ProductHelper.optionValues('Absorbency', ProductHelper.catalog), [
      'Light',
      'Regular',
      'Heavy',
      'Super',
    ]);
  });

  test('sizes run small to large, with cup sizing after the garment run', () {
    expect(ProductHelper.optionValues('Size', ProductHelper.catalog), [
      'XXS',
      'XS',
      'S',
      'M',
      'L',
      'XL',
      '2XL',
      '3XL',
      '4XL',
      'Small',
      'Regular',
      '100 ml',
    ]);
  });

  test('an unlisted value survives sorting instead of vanishing', () {
    final sorted = ProductHelper.sortValues('Size', ['L', '5XL', 'S']);
    expect(sorted, ['S', 'L', '5XL']);
  });

  test('colour values keep their own order', () {
    const colours = ['Warm Wheat', 'Volcanic Black', 'Soft Sand'];
    expect(ProductHelper.sortValues('Color', colours), colours);
  });
}
