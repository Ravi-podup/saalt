import 'package:flutter/material.dart';
import 'package:saalt/models/dashboard_item.dart';
import 'package:saalt/res/app_colors.dart';

class DashboardHelper {
  static const items = <DashboardItem>[
    DashboardItem(
      title: 'Community',
      imageAsset: 'assets/images/Community_explore.png',
      subtitle: 'Real talk, no filter',
      icon: Icons.forum_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    DashboardItem(
      title: 'Products',
      imageAsset: 'assets/images/Saalt_Products_explore.jpg',
      subtitle: 'Cups, discs & more',
      icon: Icons.shopping_bag_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    DashboardItem(
      title: 'Testimonials',
      imageAsset: 'assets/images/Testimonial_explore.png',
      subtitle: 'Stories from users',
      icon: Icons.favorite_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    DashboardItem(
      title: 'Knowledgebase',
      imageAsset: 'assets/images/Knowledgebase_explore.png',
      subtitle: 'Guides & education',
      icon: Icons.menu_book_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    DashboardItem(
      title: 'TMI Parties',
      imageAsset: 'assets/images/TMI_Parties_explore.png',
      subtitle: 'Live webinars',
      icon: Icons.celebration_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    DashboardItem(
      title: 'Saalt Show',
      imageAsset: 'assets/images/SaaltShow_explore.png',
      subtitle: 'Watch the series',
      icon: Icons.play_circle_fill_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
  ];
}
