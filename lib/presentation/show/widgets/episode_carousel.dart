import 'package:flutter/material.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/presentation/show/widgets/episode_art.dart';
import 'package:saalt/res/app_colors.dart';

/// Swipeable strip of the newest episodes, with page dots beneath. Neighbours
/// peek in at the edges so it reads as a slider rather than a static card.
class EpisodeCarousel extends StatefulWidget {
  const EpisodeCarousel({super.key, required this.episodes, this.onPlay});

  final List<Episode> episodes;
  final ValueChanged<Episode>? onPlay;

  @override
  State<EpisodeCarousel> createState() => _EpisodeCarouselState();
}

class _EpisodeCarouselState extends State<EpisodeCarousel> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 282,
          child: PageView.builder(
            key: const Key('show-carousel'),
            controller: _controller,
            itemCount: widget.episodes.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final episode = widget.episodes[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.episodes.length - 1 ? 0 : 10,
                ),
                child: _Slide(
                  episode: episode,
                  onPlay: () => widget.onPlay?.call(episode),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _Dots(count: widget.episodes.length, active: _page),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.episode, this.onPlay});

  final Episode episode;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: EpisodeArt(
                      episode: episode,
                      showWordmark: true,
                      borderRadius: 0,
                    ),
                  ),
                  if (episode.isNew)
                    const Positioned(top: 12, right: 12, child: _NewFlag()),
                  if (episode.hasVideo)
                    Positioned.fill(
                      child: Center(
                        child: VideoBadge(accent: episode.accent, size: 52),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episode.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
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
                      const Spacer(),
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          'NEW',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: i == active ? 18 : 6,
            decoration: BoxDecoration(
              color: i == active ? AppColors.rose : AppColors.hairline,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
      ],
    );
  }
}
