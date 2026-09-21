import 'package:flutter/material.dart';
import 'package:saalt/models/dashboard_item.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class DashboardHelper {
  static const items = <DashboardItem>[
    DashboardItem(
      title: 'The Saalt\nCollective',
      chipTitle: "COMMUNITY",
      imageAsset: AppImages.communityIcon,
      subtitle: 'Real talk, no filter',
      icon: Icons.forum_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      index: 0,
    ),
    DashboardItem(
      title: 'Customer\nVideos',
      chipTitle: "STORIES", //TESTIMONIALS
      imageAsset: AppImages.testimonialsIcon,
      subtitle: 'User Experiences',
      icon: Icons.favorite_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
      index: 1,
    ),
    DashboardItem(
      title: 'Saalt\nProducts',
      chipTitle: "SHOP",
      imageAsset: AppImages.shopIcon,
      subtitle: 'Cups, discs & more',
      icon: Icons.shopping_bag_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
      index: 2,
    ),
    DashboardItem(
      title: 'TMI\nParties',
      chipTitle: "VIRTUAL EVENT",
      imageAsset: AppImages.webinarIcon,
      subtitle: 'Connection & Questions',
      icon: Icons.celebration_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
      index: 3,
    ),
    DashboardItem(
      title: 'The Saalt\nShow',
      chipTitle: "PODCAST",
      imageAsset: AppImages.podcastIcon,
      subtitle: 'Watch the series',
      icon: Icons.play_circle_fill_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
      index: 4,
    ),
    DashboardItem(
      title: 'Trust\nCenter',
      chipTitle: "EDUCATION",
      imageAsset: AppImages.trustCenterIcon,
      subtitle: 'Guides and FAQ',
      icon: Icons.menu_book_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
      index: 5,
    ),
  ];
}
