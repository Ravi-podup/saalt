import 'package:flutter/material.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/presentation/show/widgets/episode_art.dart';
import 'package:saalt/res/app_colors.dart';

/// Grid form of an episode: artwork on top, then the essentials. Drops the
/// guest line the list row carries, since there is no width for it.
class EpisodeTile extends StatelessWidget {
  const EpisodeTile({super.key, required this.episode, this.onOpen});

  final Episode episode;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: EpisodeArt(episode: episode, borderRadius: 0),
                  ),
                  if (episode.isNew)
                    const Positioned(top: 8, right: 8, child: _NewFlag()),
                  if (episode.hasVideo)
                    Center(child: VideoBadge(accent: episode.accent, size: 36)),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EP ${episode.number}',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: episode.accent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          episode.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${episode.minutes} min',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewFlag extends StatelessWidget {
  const _NewFlag();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.rose,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        child: Text(
          'NEW',
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
