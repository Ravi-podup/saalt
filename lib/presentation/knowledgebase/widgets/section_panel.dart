import 'package:flutter/material.dart';
import 'package:saalt/models/article.dart';
import 'package:saalt/models/knowledge_section.dart';
import 'package:saalt/res/app_colors.dart';

/// A section of the library, previewing what is actually inside it. The
/// preview lines are the point: they give every panel different content, so
/// the page has rhythm instead of five identical rows.
class SectionPanel extends StatelessWidget {
  const SectionPanel({
    super.key,
    required this.section,
    required this.items,
    this.onTap,
    this.previewCount = 2,
  });

  final KnowledgeSection section;
  final List<Article> items;
  final VoidCallback? onTap;
  final int previewCount;

  @override
  Widget build(BuildContext context) {
    final unit = section.isVideo
        ? (items.length == 1 ? 'video' : 'videos')
        : (items.length == 1 ? 'guide' : 'guides');
    final preview = items.take(previewCount).toList();
    final remaining = items.length - preview.length;

    return Semantics(
      button: true,
      label: '${section.title}. ${items.length} $unit',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A tinted band, so each section is identifiable at a glance
                // without flooding the whole card with colour.
                Container(
                  color: section.tint,
                  padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          section.icon,
                          size: 18,
                          color: section.accent,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    section.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                                if (section.isVideo) ...[
                                  const SizedBox(width: 7),
                                  _VideoFlag(accent: section.accent),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              section.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.ink.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _CountPill(
                        text: '${items.length} $unit',
                        accent: section.accent,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in preview)
                        _PreviewLine(item: item, accent: section.accent),
                      if (remaining > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '$remaining more',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: section.accent,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: section.accent,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoFlag extends StatelessWidget {
  const _VideoFlag({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, size: 9, color: accent),
          const SizedBox(width: 2),
          Text(
            'VIDEO',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.item, required this.accent});

  final Article item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            item.isVideo
                ? Icons.play_circle_outline_rounded
                : Icons.article_outlined,
            size: 13,
            color: accent.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.minutes}m',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}
