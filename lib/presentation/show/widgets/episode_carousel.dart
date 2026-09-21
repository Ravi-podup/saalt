import 'package:flutter/material.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/presentation/show/widgets/episode_art.dart';
import 'package:saalt/res/app_colors.dart';

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

  static const _viewportFraction = 0.88;

  /// The gap a slide leaves for its neighbour.
  static const _gap = 10.0;

  static const _copyHeight = 152.0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the next, and larger type sizes push it over on any of them.
    return LayoutBuilder(
      builder: (context, box) {
        final slideWidth = box.maxWidth * _viewportFraction - _gap;
        final coverHeight = slideWidth * 9.5 / 16;
        final copyHeight =
            _copyHeight * MediaQuery.textScalerOf(context).scale(1);

        return Column(
          children: [
            SizedBox(
              height: coverHeight + copyHeight,
              child: PageView.builder(
                key: const Key('show-carousel'),
                controller: _controller,
                itemCount: widget.episodes.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final episode = widget.episodes[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == widget.episodes.length - 1 ? 0 : _gap,
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
      },
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
                    aspectRatio: 16 / 9,
                    child: episode.coverAsset == null
                        ? EpisodeArt(episode: episode, borderRadius: 0)
                        : Image.asset(
                            episode.coverAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                EpisodeArt(episode: episode, borderRadius: 0),
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
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkDeep,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'with ${episode.guest}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Divider(
                          height: 1,
                          color: Color(0xFFDBDBDB),
                        ),
                      ),
                      Text(
                        '${episode.date} · ${episode.minutes} min',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
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
        color: Color(0xffC06C6C),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        child: Text(
          'NEW',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
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
              color: i == active ? Color(0xffC95878) : Color(0xffD1D5DB),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
      ],
    );
  }
}
