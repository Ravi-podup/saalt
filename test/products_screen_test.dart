import 'package:flutter/material.dart';
import 'package:saalt/helper/product_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saalt/presentation/dashboard_screen.dart';
import 'package:saalt/presentation/products/product_detail_screen.dart';
import 'package:saalt/presentation/products/products_screen.dart';
import 'package:saalt/presentation/products/widgets/product_card.dart';
import 'package:saalt/presentation/products/widgets/promo_slider.dart';
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

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  /// 'Cups' also appears in the bottom nav bar, so target the chip row.
  Future<void> tapChip(WidgetTester tester, String label) async {
    final chips = find.byKey(const Key('product-categories'));
    final chip = find.descendant(of: chips, matching: find.text(label));
    if (chip.evaluate().isEmpty) {
      await tester.dragUntilVisible(chip, chips, const Offset(-120, 0));
    } else {
      await tester.ensureVisible(chip);
    }
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
  }

  testWidgets('listing shows the catalogue and filters it by category', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // No count while the whole catalogue is showing.
    expect(find.text('7 products'), findsNothing);
    expect(find.text('Leakproof Seamless Thong'), findsOneWidget);

    await tapChip(tester, 'Cups');
    expect(find.text('2 products'), findsOneWidget);
    expect(find.text('Saalt Cup'), findsOneWidget);
    expect(find.text('Leakproof Seamless Thong'), findsNothing);
  });

  testWidgets('header stays put while the catalogue scrolls', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final searchBefore = tester.getTopLeft(find.byType(TextField));
    await tester.drag(find.byType(ProductCard).first, const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(TextField)), searchBefore);
  });

  testWidgets('saving a product updates the favourites badge', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    expect(find.text('1'), findsNothing);

    // Scope to the card: the header now carries a favourites icon too, so an
    // unscoped byIcon finder would hit that instead.
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

  testWidgets('brand bar keeps the bag; search row carries the actions', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // The bag stays at the top, in the brand bar.
    expect(
      find.descendant(
        of: find.byType(ScreenHeader),
        matching: find.byIcon(Icons.shopping_bag_outlined),
      ),
      findsOneWidget,
    );

    // Notifications, favourites and profile sit beside the search field,
    // not in the brand bar.
    final searchRow = find.ancestor(
      of: find.byType(TextField),
      matching: find.byType(Row),
    );
    for (final icon in [
      Icons.notifications_none_rounded,
      Icons.favorite_border_rounded,
      Icons.person_outline_rounded,
    ]) {
      expect(
        find.descendant(of: searchRow, matching: find.byIcon(icon)),
        findsOneWidget,
        reason: '$icon should sit on the search row',
      );
      expect(
        find.descendant(
          of: find.byType(ScreenHeader),
          matching: find.byIcon(icon),
        ),
        findsNothing,
        reason: '$icon should not be in the brand bar',
      );
    }
  });

  testWidgets('search narrows the catalogue and reports no matches', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await tester.enterText(find.byType(TextField), 'cloudshort');
    await tester.pumpAndSettle();

    expect(find.text('1 product'), findsOneWidget);
    expect(find.text('Leakproof Comfort CloudShort'), findsOneWidget);
    expect(find.text('Leakproof Seamless Thong'), findsNothing);

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
    expect(find.text('Leakproof Seamless Thong'), findsOneWidget);
  });

  testWidgets('bottom bar shows four tabs with Home current', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    final bar = find.byType(ProductsNavBar);
    expect(bar, findsOneWidget);

    for (final label in ['Home', 'Underwear', 'Cups', 'Bags']) {
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
    for (final label in ['Underwear', 'Cups', 'Bags']) {
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
    await tester.tap(find.descendant(of: bar, matching: find.text('Cups')));
    await tester.pumpAndSettle();

    // Still the full catalogue, still on the same screen.
    expect(find.byType(ProductsScreen), findsOneWidget);
    expect(find.text('2 products'), findsNothing);
    expect(find.text('Leakproof Seamless Thong'), findsOneWidget);
  });

  testWidgets('liking a product does not touch the bag count', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // Back comes first in the header, the bag second.
    final bag = find
        .descendant(
          of: find.byType(ScreenHeader),
          matching: find.byType(CircleIconButton),
        )
        .last;

    // Heart the first product.
    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.byIcon(Icons.favorite_border_rounded),
      ),
    );
    await tester.pumpAndSettle();

    // The bag is still empty and still shows its outline glyph.
    expect(tester.widget<CircleIconButton>(bag).badgeCount, 0);
    expect(
      find.descendant(
        of: find.byType(ScreenHeader),
        matching: find.byIcon(Icons.shopping_bag_outlined),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the listing cannot add to the bag; it routes to the choice', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    // No transactional CTA on the listing.
    expect(find.text('BUY NOW'), findsNothing);
    expect(find.text('Choose size'), findsWidgets);

    final bag = find
        .descendant(
          of: find.byType(ScreenHeader),
          matching: find.byType(CircleIconButton),
        )
        .last;
    expect(tester.widget<CircleIconButton>(bag).badgeCount, 0);

    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.text('Choose size'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsOneWidget);
  });

  testWidgets('detail requires every option before adding to the bag', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.text('Choose size'),
      ),
    );
    await tester.pumpAndSettle();

    // Absorbency has a single value so it is preselected; Size and Color are
    // still open, so the bar refuses and names what is missing.
    expect(find.text('Add to bag'), findsNothing);
    expect(find.text('Choose size'), findsOneWidget);

    await _pickOption(tester, 'M');
    expect(find.text('Choose color'), findsOneWidget);

    await _pickOption(tester, 'Warm Wheat');
    expect(find.text('Add to bag'), findsOneWidget);
  });

  testWidgets('adding a resolved variant fills the bag by quantity', (
    tester,
  ) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

    await tester.tap(
      find.descendant(
        of: find.byType(ProductCard).first,
        matching: find.text('Choose size'),
      ),
    );
    await tester.pumpAndSettle();

    await _pickOption(tester, 'M');
    await _pickOption(tester, 'Warm Wheat');

    // Bump quantity, which lives here rather than on the listing.
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

    // Back on the listing, the badge counts items and names the variant.
    expect(find.byType(ProductsScreen), findsOneWidget);
    final bag = find
        .descendant(
          of: find.byType(ScreenHeader),
          matching: find.byType(CircleIconButton),
        )
        .last;
    expect(tester.widget<CircleIconButton>(bag).badgeCount, 2);
  });

  testWidgets('active favourites icon is rose, not ink', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const MaterialApp(home: ProductsScreen()));

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
}
