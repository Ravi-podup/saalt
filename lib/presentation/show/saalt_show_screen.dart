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
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/presentation/show/widgets/view_toggle.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';

class SaaltShowScreen extends StatefulWidget {
  const SaaltShowScreen({super.key});

  @override
  State<SaaltShowScreen> createState() => _SaaltShowScreenState();
}

class _SaaltShowScreenState extends State<SaaltShowScreen> {
  String _format = 'All';
  bool _isGrid = false;

  List<Episode> get _visible => _format == 'All'
      ? ShowHelper.episodes
      : ShowHelper.episodes.where((e) => e.format == _format).toList();

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
    if (!episode.hasVideo) {
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          title: episode.title,
          subtitle: 'EP ${episode.number} · with ${episode.guest}',
          url: episode.videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final episodes = _visible;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'The Saalt Show',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('show-body'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  ShowHero(
                    // onSubscribe: () => _toast('Subscribed to The Saalt Show'),
                    // onEpisodes: () => _toast('Jumping to episodes'),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('Latest'),
                  const SizedBox(height: 12),
                  EpisodeCarousel(
                    episodes: ShowHelper.episodes.take(3).toList(),
                    onPlay: _play,
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(
                    'All episodes',
                    trailing: ViewToggle(
                      isGrid: _isGrid,
                      onChanged: (v) => setState(() => _isGrid = v),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // The show's three formats double as the episode filter,
                  // rather than sitting in a separate explainer block.
                  _FormatBar(
                    formats: ShowHelper.formats,
                    selected: _format,
                    onSelect: (f) => setState(() => _format = f),
                  ),
                  const SizedBox(height: 12),
                  if (episodes.isEmpty)
                    const _EmptyState()
                  else if (_isGrid)
                    GridView.builder(
                      key: const Key('show-grid'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: episodes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.74,
                          ),
                      itemBuilder: (context, index) => EpisodeTile(
                        episode: episodes[index],
                        onOpen: () => _play(episodes[index]),
                      ),
                    )
                  else
                    for (final episode in episodes) ...[
                      EpisodeCard(
                        episode: episode,
                        onPlay: () => _play(episode),
                      ),
                      const SizedBox(height: 10),
                    ],
                  const SizedBox(height: 16),
                  const _SectionLabel('Where to listen'),
                  const SizedBox(height: 12),
                  PlatformRow(
                    platforms: ShowHelper.platforms,
                    // onOpen: (name) => _toast('Opening $name'),
                  ),
                  const SizedBox(height: 24),
                  AskCard(
                    // onSend: (question) => _toast('Sent to Cherie')
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selected: 'Home',
        items: [
          BottomNavItem.home(),
          const BottomNavItem(label: 'Episodes', icon: Icons.podcasts_rounded),
          const BottomNavItem(label: 'Shop', icon: Icons.shopping_bag_outlined),
          const BottomNavItem(label: 'Blog', icon: Icons.article_outlined),
          const BottomNavItem(label: 'About', icon: Icons.info_outline_rounded),
        ],
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
      height: 38,
      child: ListView.separated(
        key: const Key('show-formats'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
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
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.inkMuted,
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
  const _SectionLabel(this.text, {this.trailing});

  final String text;

  /// Optional control on the right, such as the list/grid switch.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
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
