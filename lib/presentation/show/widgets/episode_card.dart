import 'package:flutter/material.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/presentation/show/widgets/episode_art.dart';
import 'package:saalt/res/app_colors.dart';

/// Episode row: tinted art with a play affordance, then title, guest and meta.
class EpisodeCard extends StatelessWidget {
  const EpisodeCard({super.key, required this.episode, this.onPlay});

  final Episode episode;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPlay,
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
              _Art(episode: episode),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'EP ${episode.number}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: episode.accent,
                          ),
                        ),
                        if (episode.isNew) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.rose,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      episode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'with ${episode.guest}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${episode.date} · ${episode.minutes} min',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      width: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          EpisodeArt(episode: episode),
          if (episode.hasVideo) VideoBadge(accent: episode.accent, size: 30),
        ],
      ),
    );
  }
}
