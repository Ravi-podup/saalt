import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Where to listen. Scrolls horizontally so the list can grow.
class PlatformRow extends StatelessWidget {
  const PlatformRow({super.key, required this.platforms, this.onOpen});

  final List<String> platforms;
  final ValueChanged<String>? onOpen;

  static const _logos = <String, String>{
    'Apple Podcasts': AppImages.applePodcastsIcon,
    'Spotify': AppImages.spotifyIcon,
    'YouTube': AppImages.youtubeIcon,
    'Amazon Music': AppImages.amazonIcon,
    'iHeartRadio': AppImages.iheartIcon,
    'Pocket Casts': AppImages.pocketCastIcon,
    'Overcast': AppImages.overcastIcon,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        key: const Key('show-platforms'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: platforms.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final name = platforms[index];
          final logo = _logos[name];
          return Semantics(
            button: true,
            label: 'Listen on $name',
            child: GestureDetector(
              onTap: () => onOpen?.call(name),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 66,
                child: Column(
                  children: [
                    if (logo == null)
                      const _FallbackMark()
                    else
                      Image.asset(
                        logo,
                        height: 48,
                        width: 48,
                        fit: BoxFit.contain,
                        // A platform added without artwork still gets a mark
                        // rather than a broken-image box.
                        errorBuilder: (_, _, _) => const _FallbackMark(),
                      ),
                    const SizedBox(height: 7),
                    Text(
                      name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Stands in for a platform we hold no mark for.
class _FallbackMark extends StatelessWidget {
  const _FallbackMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.hairline),
      ),
      child: const Icon(Icons.podcasts_rounded, size: 22, color: AppColors.ink),
    );
  }
}
