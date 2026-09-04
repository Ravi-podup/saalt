import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 13});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = rating - i;
        final IconData icon;
        if (filled >= 0.75) {
          icon = Icons.star_rounded;
        } else if (filled >= 0.25) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: size, color: AppColors.rose);
      }),
    );
  }
}
