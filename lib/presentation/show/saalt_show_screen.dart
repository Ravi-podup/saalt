import 'package:flutter/material.dart';
import 'package:saalt/helper/show_helper.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/presentation/show/widgets/ask_card.dart';
import 'package:saalt/presentation/show/widgets/episode_card.dart';
import 'package:saalt/presentation/show/widgets/episode_carousel.dart';
import 'package:saalt/presentation/show/widgets/episode_tile.dart';
import 'package:saalt/presentation/show/widgets/platform_row.dart';
import 'package:saalt/presentation/show/widgets/show_hero.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/presentation/widgets/view_toggle.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

class SaaltShowScreen extends StatefulWidget {
  const SaaltShowScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.saaltShowScreen);
  }

  @override
  State<SaaltShowScreen> createState() => _SaaltShowScreenState();
}

class _SaaltShowScreenState extends State<SaaltShowScreen> {
  String _format = 'All Episodes';
  bool _isGrid = false;

  /// The three episodes with artwork. The chips above them mark themselves
  /// but do not narrow the list.
  List<Episode> get _visible => ShowHelper.episodes.take(3).toList();

  // void _toast(String message) {
  //   final messenger = ScaffoldMessenger.of(context);
  //   messenger.hideCurrentSnackBar();
  //   messenger.showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: AppColors.ink,
  //       duration: const Duration(milliseconds: 1400),
  //     ),
  //   );
  // }

  /// Watchable episodes open the player as its own route. Self-contained on
  /// purpose, so it does not depend on the commented-out toast helper.
  void _play(Episode episode) {
    // Captured in a local so the null check promotes: a field on another
    // object cannot be promoted in place.
    final url = episode.videoUrl;
    if (url == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Episode ${episode.number} is not up yet'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          duration: const Duration(milliseconds: 1400),
        ),
      );
      return;
    }
    VideoPlayerScreen.open(
      context,
      title: episode.title,
      subtitle: 'EP ${episode.number} · with ${episode.guest}',
      url: url,
    );
  }

  @override
  Widget build(BuildContext context) {
    final episodes = _visible;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ShowHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                key: const Key('show-body'),
                padding: const EdgeInsets.only(top: 4, bottom: 28),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ShowHero(
                      // onSubscribe: () => _toast('Subscribed to The Saalt Show'),
                      // onEpisodes: () => _toast('Jumping to episodes'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _SectionLabel('Latest Episodes')),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC95878),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  EpisodeCarousel(
                    episodes: ShowHelper.episodes.take(3).toList(),
                    onPlay: _play,
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Watch on your favorite platforms',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        // letterSpacing: -0.3,
                        color: AppColors.inkDeep,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PlatformRow(platforms: ShowHelper.platforms),
                  const SizedBox(height: 26),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Expanded(child: _SectionLabel('All Episodes')),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: ViewToggle(
                            isGrid: _isGrid,
                            onChanged: (v) => setState(() => _isGrid = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // The show's formats double as the episode filter, with the
                  // view switch on the same line rather than up in the title.
                  Row(
                    children: [
                      Expanded(
                        child: _FormatBar(
                          formats: ShowHelper.formats,
                          selected: _format,
                          onSelect: (f) => setState(() => _format = f),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (episodes.isEmpty)
                    const _EmptyState()
                  else if (_isGrid)
                    GridView.builder(
                      key: const Key('show-grid'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: episodes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.69,
                          ),
                      itemBuilder: (context, index) => EpisodeTile(
                        episode: episodes[index],
                        onOpen: () => _play(episodes[index]),
                      ),
                    )
                  else
                    for (final episode in episodes) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: EpisodeCard(
                          episode: episode,
                          onPlay: () => _play(episode),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AskCard(
                      // onSend: (question) => _toast('Sent to Cherie')
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        selected: 'Saalt',
        items: BottomNavItem.show,
      ),
    );
  }
}

class _FormatBar extends StatelessWidget {
  const _FormatBar({
    required this.formats,
    required this.selected,
    required this.onSelect,
  });

  final List<String> formats;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        key: const Key('show-formats'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: formats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final format = formats[index];
          final isActive = format == selected;
          return Material(
            color: isActive ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => onSelect(format),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Text(
                  format,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? Colors.white : Color(0xff4B5563),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.4,
            color: AppColors.inkDeep,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(
          'No episodes in that format yet',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

/// Back on the left, the show named in the middle, the viewer's own face
/// opposite. Same shape as the Collective, Stories and TMI Parties.
class _ShowHeader extends StatelessWidget {
  const _ShowHeader({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          BackButtonWidget(onTap: onBack),
          const Expanded(
            child: Text(
              'The Saalt Show',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.inkDeep,
              ),
            ),
          ),
          Image.asset(
            AppImages.profilePictureCircleImage,
            height: 40,
            width: 40,
          ),
        ],
      ),
    );
  }
}
