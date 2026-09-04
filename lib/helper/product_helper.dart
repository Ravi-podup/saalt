import 'package:flutter/material.dart';
import 'package:saalt/models/product.dart';
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
      name: 'Menstrual Disc',
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
  ];

  /// Brand banners for the shop slider. Converted to JPEG because Flutter
  /// cannot decode the AVIF originals.
  static const banners = <String>[
    'assets/images/slider1.jpg',
    'assets/images/slider2.jpg',
    'assets/images/slider3.jpg',
  ];
}
