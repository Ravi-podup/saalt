import 'package:flutter/material.dart';
import 'package:saalt/models/article.dart';
import 'package:saalt/res/app_colors.dart';

/// Compact list row: tinted thumbnail, category, title and read time. Reads
/// densely so a long library stays scannable.
class ArticleRow extends StatelessWidget {
  const ArticleRow({super.key, required this.article, this.onTap});

  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  color: article.tint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  article.isVideo ? Icons.play_arrow_rounded : article.icon,
                  size: article.isVideo ? 30 : 26,
                  color: article.accent,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: article.accent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          article.isVideo
                              ? Icons.play_circle_outline_rounded
                              : Icons.schedule_rounded,
                          size: 12,
                          color: AppColors.inkFaint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.minutes} min '
                          '${article.isVideo ? 'watch' : 'read'}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.inkFaint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 24),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
