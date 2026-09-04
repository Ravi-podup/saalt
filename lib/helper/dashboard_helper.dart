import 'package:flutter/material.dart';
import 'package:saalt/models/dashboard_item.dart';
import 'package:saalt/res/app_colors.dart';

class DashboardHelper {
  static const items = <DashboardItem>[
    DashboardItem(
      title: 'Community',
      subtitle: 'Real talk, no filter',
      icon: Icons.forum_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    DashboardItem(
      title: 'Products',
      subtitle: 'Cups, discs & more',
      icon: Icons.shopping_bag_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    DashboardItem(
      title: 'Testimonials',
      subtitle: 'Stories from users',
      icon: Icons.favorite_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    DashboardItem(
      title: 'Knowledgebase',
      subtitle: 'Guides & education',
      icon: Icons.menu_book_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    DashboardItem(
      title: 'TMI Parties',
      subtitle: 'Live webinars',
      icon: Icons.celebration_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    DashboardItem(
      title: 'Saalt Show',
      subtitle: 'Watch the series',
      icon: Icons.play_circle_fill_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
  ];
}
