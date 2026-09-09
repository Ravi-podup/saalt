import 'package:flutter/material.dart';
import 'package:saalt/models/collection.dart';
import 'package:saalt/models/product.dart';
import 'package:saalt/models/review_quote.dart';
import 'package:saalt/models/shop_category.dart';
import 'package:saalt/res/app_colors.dart';

class ProductHelper {
  static const catalog = <Product>[
    Product(
      name: 'Leakproof Seamless Thong',
      options: [
        ProductOption(name: 'Absorbency', values: ['Light']),
        ProductOption(
          name: 'Size',
          values: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Rich Earth',
            'Deep Umber',
            'Smooth Terracotta',
            'Soft Sand',
            'Electric Raspberry',
            'Lightning Indigo',
            'Midnight Sky',
            'Crimson Rose',
            'Sunset Mauve',
            'Soft Lavender',
            'Warm Wheat',
          ],
        ),
      ],
      imageAsset: 'assets/images/leakproof_seamless_thong.jpg',
      blurb:
          'This is the pair you put on and then promptly forget about. The one '
          'that lets you pull on leggings and skip the half-squat mirror check.',
      price: 30,
      rating: 5,
      reviews: 272,
      category: 'Underwear',
      badge: 'Bestseller',
      icon: Icons.spa_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Product(
      name: 'Leakproof Comfort CloudShort',
      options: [
        ProductOption(name: 'Absorbency', values: ['Super', 'Heavy']),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Midnight Sky',
            'Seaspray Green',
            'Soft Lavender',
            'Rich Ruby',
            'Deep Marine',
          ],
        ),
      ],
      imageAsset: 'assets/images/leakproof_comfort_cloudshort.jpg',
      blurb:
          'You asked, we listened. Our CloudShort has extended gusset coverage '
          'for all-night comfort and protection for heavy periods, bladder '
          'leaks, and postpartum care.',
      price: 47,
      rating: 5,
      reviews: 615,
      category: 'Underwear',
      icon: Icons.nights_stay_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    Product(
      name: 'Leakproof Seamless Brief',
      options: [
        ProductOption(
          name: 'Absorbency',
          values: ['Super', 'Heavy', 'Regular'],
        ),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Midnight Sky',
            'Crimson Rose',
            'Smooth Terracotta',
            'Sunset Mauve',
            'Soft Lavender',
            'Warm Wheat',
            'Soft Sand',
            'Rich Earth',
            'Deep Umber',
            'Electric Raspberry',
            'Lightning Indigo',
          ],
        ),
      ],
      imageAsset: 'assets/images/leakproof_seamless_brief.jpg',
      blurb:
          'Your favorite full-coverage style with a barely-there feel. It\'s '
          'the pair you reach for on days you want zero distractions.',
      price: 39,
      rating: 5,
      reviews: 627,
      category: 'Underwear',
      icon: Icons.favorite_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    Product(
      name: 'Saalt Disc Duo',
      imageAsset: 'assets/images/saalt_disc_duo.jpg',
      blurb:
          'Why you\'ll love it: two discs are better than one! Get both sizes '
          'of the fan-favorite Saalt Disc for less when you purchase together '
          'as a Duo.',
      price: 59,
      compareAtPrice: 68,
      rating: 4,
      reviews: 298,
      category: 'Bundles',
      badge: 'Save \$9',
      icon: Icons.all_inclusive_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
    Product(
      name: 'Saalt Cup',
      options: [
        ProductOption(
          name: 'Color',
          values: ['Seafoam Green', 'Himalayan Pink', 'Ocean Blue'],
        ),
        ProductOption(name: 'Size', values: ['Regular', 'Small']),
      ],
      imageAsset: 'assets/images/saalt_cup.jpg',
      blurb:
          'The original. Medical-grade silicone, twelve hours of protection, '
          'and up to ten years of use from a single cup.',
      price: 32,
      rating: 4.5,
      reviews: 1204,
      category: 'Cups',
      badge: 'Most loved',
      icon: Icons.water_drop_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Product(
      name: 'Saalt Soft Cup',
      options: [
        ProductOption(
          name: 'Color',
          values: ['Desert Blush', 'Mist Grey', 'Mountain Iris'],
        ),
        ProductOption(name: 'Size', values: ['Regular', 'Small']),
      ],
      imageAsset: 'assets/images/saalt_soft_cup.jpg',
      blurb:
          'Our softest cup, designed for sensitive bladders and cramping '
          'without giving up a leakproof seal.',
      price: 32,
      rating: 4.5,
      reviews: 842,
      category: 'Cups',
      icon: Icons.bubble_chart_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Product(
      name: 'Saalt Disc',
      options: [
        ProductOption(
          name: 'Color/Size',
          values: ['Coastal Blue (Regular)', 'Sunset Coral (Small)'],
        ),
      ],
      imageAsset: 'assets/images/menstrual_disc.jpg',
      blurb:
          'Sits at the base of the cervix for a truly can\'t-feel-it fit. '
          'Twelve hours of mess-free wear, and it works for wear-anywhere days.',
      price: 35,
      rating: 4.5,
      reviews: 511,
      category: 'Discs',
      icon: Icons.blur_circular_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Product(
      name: 'Saalt Teen Cup',
      imageAsset: 'assets/images/saalt_teen_cup.jpg',
      blurb:
          'Sized and softened for a first cup, with a shorter stem so it sits '
          'comfortably on a smaller frame.',
      price: 32,
      rating: 4.5,
      reviews: 187,
      category: 'Teen',
      badge: 'For first cups',
      icon: Icons.spa_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      options: [
        ProductOption(name: 'Color', values: ['Wild Rose']),
      ],
    ),
    Product(
      name: 'Saalt Cup Wash',
      imageAsset: 'assets/images/saalt_cup_wash.jpg',
      blurb:
          'A pH-balanced wash made for silicone. Keeps the seal intact, which '
          'ordinary soap slowly degrades.',
      price: 14,
      rating: 4.5,
      reviews: 412,
      category: 'Cleaning',
      icon: Icons.soap_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
      options: [
        ProductOption(name: 'Size', values: ['100 ml']),
      ],
    ),
    Product(
      name: 'Saalt Steamer',
      imageAsset: 'assets/images/saalt_steamer.jpg',
      blurb:
          'Sterilises a cup or disc in three minutes without a saucepan. '
          'Water in, lid on, done.',
      price: 39,
      rating: 4.5,
      reviews: 96,
      category: 'Cleaning',
      badge: 'New',
      icon: Icons.local_fire_department_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
      options: [
        ProductOption(name: 'Color', values: ['Blue Dusk', 'Cloud', 'Blush']),
      ],
    ),
    Product(
      name: 'Leakproof Cotton Lace Trim Thong',
      imageAsset: 'assets/images/lace_trim_thong.jpg',
      blurb: 'Your favorite cotton pair, effortlessly elevated.',
      price: 28,
      rating: 4.5,
      reviews: 208,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
      options: [
        ProductOption(name: 'Absorbency', values: ['Light']),
        ProductOption(
          name: 'Size',
          values: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: ['Volcanic Black', 'Seaglass', 'Dawn Sky'],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Cotton Lace Trim Brief',
      imageAsset: 'assets/images/lace_trim_brief.jpg',
      blurb: 'Your favorite cotton pair, effortlessly elevated.',
      price: 32,
      rating: 5.0,
      reviews: 477,
      category: 'Underwear',
      badge: 'New',
      icon: Icons.checkroom_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      options: [
        ProductOption(name: 'Absorbency', values: ['Heavy']),
        ProductOption(
          name: 'Size',
          values: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: ['Volcanic Black', 'Seaglass', 'Dawn Sky'],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Comfort Brief',
      imageAsset: 'assets/images/comfort_brief.jpg',
      blurb:
          'Feels like clouds. Works like whoa. Your everyday, full '
          'coverage go-to for no pad, no problem confidence.',
      price: 39,
      rating: 4.5,
      reviews: 1903,
      category: 'Underwear',
      badge: 'Bestseller',
      icon: Icons.checkroom_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
      options: [
        ProductOption(name: 'Absorbency', values: ['Super', 'Heavy']),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Deep Plum',
            'Soft Lavender',
            'Rich Ruby',
            'Deep Marine',
          ],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Seamless Bikini',
      imageAsset: 'assets/images/seamless_bikini.jpg',
      blurb:
          'Slip into any outfit without rethinking your underwear. The '
          'just-cheeky-enough, super flattering style for any occasion.',
      price: 36,
      rating: 5.0,
      reviews: 598,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
      options: [
        ProductOption(name: 'Absorbency', values: ['Super', 'Regular']),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Midnight Sky',
            'Crimson Rose',
            'Smooth Terracotta',
            'Sunset Mauve',
            'Soft Lavender',
            'Rich Earth',
            'Deep Umber',
            'Soft Sand',
            'Warm Wheat',
            'Electric Raspberry',
            'Lightning Indigo',
          ],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Seamless High Waist',
      imageAsset: 'assets/images/seamless_high_waist.jpg',
      blurb:
          'All of the freedom, none of the panty lines. A little more '
          'coverage without sacrificing that second-skin feel.',
      price: 42,
      rating: 4.5,
      reviews: 641,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
      options: [
        ProductOption(name: 'Absorbency', values: ['Regular']),
        ProductOption(
          name: 'Size',
          values: ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Volcanic Black',
            'Rich Earth',
            'Deep Umber',
            'Smooth Terracotta',
            'Warm Wheat',
            'Soft Sand',
            'Electric Raspberry',
            'Lightning Indigo',
            'Midnight Sky',
            'Crimson Rose',
            'Sunset Mauve',
            'Soft Lavender',
          ],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Cotton Brief',
      imageAsset: 'assets/images/cotton_brief.jpg',
      blurb:
          'Cute, comfy, cotton—upgraded. Breathable confidence. Your '
          'go-to, full coverage pair that will go the distance.',
      price: 29,
      rating: 4.5,
      reviews: 428,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
      options: [
        ProductOption(
          name: 'Absorbency',
          values: ['Super', 'Heavy', 'Regular'],
        ),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: ['Volcanic Black', 'Seashell', 'Pink Dawn', 'Thistle Bloom'],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Mesh Thong',
      imageAsset: 'assets/images/mesh_thong.jpg',
      blurb:
          'Live free of VPL (visible panty lines) and light leaks with '
          'our next-best-thing-to-nothing thong.',
      price: 30,
      rating: 4.0,
      reviews: 167,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
      options: [
        ProductOption(name: 'Absorbency', values: ['Light']),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: [
            'Moonlit Mauve',
            'Volcanic Black',
            'Blue Rain',
            'Amber Stone',
          ],
        ),
      ],
    ),
    Product(
      name: 'Leakproof Cotton Sleep Short',
      imageAsset: 'assets/images/cotton_sleep_short.jpg',
      blurb: 'Count sheep, not leaks!',
      price: 49,
      rating: 4.5,
      reviews: 438,
      category: 'Underwear',
      icon: Icons.checkroom_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      options: [
        ProductOption(name: 'Absorbency', values: ['Super']),
        ProductOption(
          name: 'Size',
          values: ['XXS', 'XS', 'S', 'M', 'L', 'XL', '2XL', '3XL', '4XL'],
        ),
        ProductOption(
          name: 'Color',
          values: ['Volcanic Black', 'Seashell', 'Pink Dawn', 'Thistle Bloom'],
        ),
      ],
    ),
  ];

  /// Brand banners for the shop slider. Converted to JPEG because Flutter
  /// cannot decode the AVIF originals.
  static const banners = <String>[
    'assets/images/slider1.jpg',
    'assets/images/slider2.jpg',
    'assets/images/slider3.jpg',
  ];

  /// The two best-seller groups the site splits its shelf into.
  static const bestSellerGroups = <String, Set<String>>{
    'Saalt Wear': {'Underwear'},
    'Cups & Discs': {'Cups', 'Discs'},
  };

  static List<Product> bestSellers(String group) {
    final wanted = bestSellerGroups[group] ?? const <String>{};
    return catalog.where((p) => wanted.contains(p.category)).toList();
  }

  /// The shop-by-category row, mirroring the site's collections.
  static const categories = <ShopCategory>[
    ShopCategory(
      label: 'Leakproof Underwear',
      chipLabel: 'Underwear',
      imageAsset: 'assets/images/leakproof_seamless_brief.jpg',
      matches: {'Underwear'},
    ),
    ShopCategory(
      label: 'Cups & Discs',
      chipLabel: 'Cups & Discs',
      imageAsset: 'assets/images/menstrual_disc.jpg',
      matches: {'Cups', 'Discs'},
    ),
    ShopCategory(
      label: 'Teen',
      chipLabel: 'Teen',
      imageAsset: 'assets/images/saalt_teen_cup.jpg',
      matches: {'Teen'},
    ),
    ShopCategory(
      label: 'Cleaning & Accessories',
      chipLabel: 'Cleaning',
      imageAsset: 'assets/images/saalt_steamer.jpg',
      matches: {'Cleaning'},
    ),
    ShopCategory(
      label: 'Bundles',
      chipLabel: 'Bundles',
      imageAsset: 'assets/images/saalt_disc_duo.jpg',
      matches: {'Bundles'},
    ),
  ];

  static List<Product> inCategory(ShopCategory category) =>
      catalog.where((p) => category.matches.contains(p.category)).toList();

  /// Editorial panel promoting the underwear line.
  static const whySaaltWearImage = 'assets/images/why_saalt_wear.jpg';

  /// Promoted collections, shown under the Why Saalt Wear panel.
  static const collections = <Collection>[
    Collection(
      label: 'Cotton Lace Trim',
      imageAsset: 'assets/images/lace-trim-card_600x.webp',
      opensCategory: 'Leakproof Underwear',
      flag: 'NEW',
    ),
    Collection(
      label: 'hanky panky+ (powered by Saalt)',
      imageAsset: 'assets/images/hanky-panky_poweredbySaalt.avif',
      opensCategory: 'Leakproof Underwear',
    ),
    Collection(
      label: 'Our Best Deals',
      imageAsset: 'assets/images/OurBestDeals.avif',
      opensCategory: 'Bundles',
      discount: ['Up to', '50% off'],
    ),
  ];

  /// Pull-quote reviews, shown between the Why Saalt Wear panel and the
  /// promoted collections.
  static const reviewQuotes = <ReviewQuote>[
    ReviewQuote(
      product: 'Saalt Cup',
      lead: 'The Saalt Cup is my bestie! I’ve had it for 5 years. ',
      emphasis: 'Imagine how much money I\'ve saved not buying tampons!',
      author: 'Kels',
    ),
    ReviewQuote(
      product: 'Saalt Disc',
      lead:
          'Truly the best invention ever! There is a learning curve, but I '
          'promise this will ',
      emphasis: 'change your life for the better!!',
      author: 'Dava',
    ),
    ReviewQuote(
      product: 'Leakproof Seamless Thong',
      lead: 'I was skeptical at first, but honestly they\'re ',
      emphasis:
          'very thin and comfortable — the perfect thong to wear under '
          'leggings.',
      author: 'Euna',
    ),
  ];

  /// Canonical order for option values. Neither the feed order nor an
  /// alphabetical sort is meaningful here: absorbency runs light to heavy,
  /// and sizes run small to large.
  static const optionOrder = <String, List<String>>{
    'Absorbency': ['Light', 'Regular', 'Heavy', 'Super'],
    'Size': [
      'XXS',
      'XS',
      'S',
      'M',
      'L',
      'XL',
      '2XL',
      '3XL',
      '4XL',
      // Cup and accessory sizing sits after the garment run.
      'Small',
      'Regular',
      '100 ml',
    ],
  };

  /// Sorts [values] into the canonical order for [optionName]. Anything not
  /// listed keeps its original position at the end, so a new colourway or
  /// size shows up rather than vanishing.
  static List<String> sortValues(String optionName, Iterable<String> values) {
    final order = optionOrder[optionName];
    if (order == null) return values.toList();
    final known = <String>[];
    final unknown = <String>[];
    for (final value in values) {
      (order.contains(value) ? known : unknown).add(value);
    }
    known.sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
    return [...known, ...unknown];
  }

  /// Distinct values of one option across [from], in canonical order.
  static List<String> optionValues(String optionName, List<Product> from) {
    final seen = <String>[];
    for (final product in from) {
      for (final option in product.options) {
        if (option.name != optionName) continue;
        for (final value in option.values) {
          if (!seen.contains(value)) seen.add(value);
        }
      }
    }
    return sortValues(optionName, seen);
  }

  /// True when [product] offers at least one of [values] for [optionName].
  /// A product with no such option is excluded, which is what a shopper
  /// filtering on size expects.
  static bool offers(Product product, String optionName, Set<String> values) {
    if (values.isEmpty) return true;
    return product.options.any(
      (o) => o.name == optionName && o.values.any(values.contains),
    );
  }

  /// How many colourways a product comes in.
  static int colourCount(Product product) => product.options
      .where((o) => o.name == 'Color' || o.name == 'Color/Size')
      .fold(0, (sum, o) => sum + o.values.length);

  /// Real colour for each named colourway, so the picker can show swatches
  /// rather than the words. Anything unlisted falls back to a neutral.
  static const _swatches = <String, Color>{
    'Amber Stone': Color(0xFFC08A4A),
    'Blue Dusk': Color(0xFF6B7FA3),
    'Blue Rain': Color(0xFF8CA8C8),
    'Blush': Color(0xFFEFC9C6),
    'Cloud': Color(0xFFE8EAED),
    'Coastal Blue (Regular)': Color(0xFF7FA8C9),
    'Crimson Rose': Color(0xFFA83246),
    'Dawn Sky': Color(0xFFBFD0E0),
    'Deep Marine': Color(0xFF1E3A5F),
    'Deep Plum': Color(0xFF4A2740),
    'Deep Umber': Color(0xFF4A382C),
    'Desert Blush': Color(0xFFDCA9A0),
    'Electric Raspberry': Color(0xFFC42A64),
    'Himalayan Pink': Color(0xFFE8A0A8),
    'Lightning Indigo': Color(0xFF3B3E8C),
    'Midnight Sky': Color(0xFF1B2440),
    'Mist Grey': Color(0xFFB9BCC1),
    'Moonlit Mauve': Color(0xFFA98CA5),
    'Mountain Iris': Color(0xFF7A6E9E),
    'Ocean Blue': Color(0xFF2F6690),
    'Pink Dawn': Color(0xFFF0BFC4),
    'Rich Earth': Color(0xFF6B4A38),
    'Rich Ruby': Color(0xFF8E1F35),
    'Seafoam Green': Color(0xFFA8CFC0),
    'Seaglass': Color(0xFFBFD8D2),
    'Seashell': Color(0xFFF1E3DA),
    'Seaspray Green': Color(0xFF8FBFAE),
    'Smooth Terracotta': Color(0xFFB5674C),
    'Soft Lavender': Color(0xFFC9BBD8),
    'Soft Sand': Color(0xFFE3D5C3),
    'Sunset Coral (Small)': Color(0xFFE88A6F),
    'Sunset Mauve': Color(0xFFB98192),
    'Thistle Bloom': Color(0xFF9E7FA8),
    'Volcanic Black': Color(0xFF22242A),
    'Warm Wheat': Color(0xFFD9C09B),
    'Wild Rose': Color(0xFFC4677E),
  };

  static Color swatchFor(String colourName) =>
      _swatches[colourName] ?? AppColors.inkFaint;

  /// True when we hold a real colour for every value, and so can drop the
  /// words for swatches. A part-known list keeps its chips, since half
  /// swatches and half grey discs reads as a bug.
  static bool hasSwatches(Iterable<String> values) =>
      values.every(_swatches.containsKey);

  /// Photographs for the detail gallery. Only one shot per product is in
  /// assets today, so the strip is filled out with the other photographs from
  /// the same category. Give [Product] a gallery field once the extra angles
  /// land and this can return those instead.
  static List<String> galleryFor(Product product) {
    final own = product.imageAsset;
    return <String>[
      ?own,
      for (final other in catalog)
        if (other.category == product.category &&
            other.name != product.name &&
            other.imageAsset != null)
          other.imageAsset!,
    ].take(5).toList();
  }

  /// What one of this product is called, for bundle wording such as
  /// "3 pairs". Taken from the category, since product names end in too many
  /// different nouns to read well ("1 High Waist").
  static ({String one, String many}) unitNoun(Product product) =>
      switch (product.category) {
        'Underwear' => (one: 'pair', many: 'pairs'),
        'Cups' || 'Teen' => (one: 'cup', many: 'cups'),
        'Discs' => (one: 'disc', many: 'discs'),
        'Bundles' => (one: 'set', many: 'sets'),
        _ => (one: 'item', many: 'items'),
      };

  /// How many drops to draw beside an absorbency level.
  static int dropsFor(String level) => switch (level) {
    'Light' => 1,
    'Regular' => 2,
    'Heavy' => 3,
    'Super' => 4,
    _ => 1,
  };
}
