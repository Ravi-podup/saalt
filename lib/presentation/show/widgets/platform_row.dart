import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Where to watch. Scrolls horizontally so the list can grow.
class PlatformRow extends StatelessWidget {
  const PlatformRow({super.key, required this.platforms, this.onOpen});

  final List<String> platforms;
  final ValueChanged<String>? onOpen;

  static const _border = Color(0xFFBABABA);

  static const _logos = <String, String>{
    'YouTube': AppImages.youtubeIcon,
    'Spotify': AppImages.spotifyIcon,
    'Apple': AppImages.appleIcon,
    'Amazon': AppImages.amazonIcon,
    'Vimeo': AppImages.vimeoIcon,
    'iHeartRadio': AppImages.iheartRadioIcon,
    'Overcast': AppImages.overcastIcon,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        key: const Key('show-platforms'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: platforms.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final name = platforms[index];
          final logo = _logos[name];

          return Semantics(
            button: true,
            label: 'Watch on $name',
            child: GestureDetector(
              onTap: () => onOpen?.call(name),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (logo == null)
                      const _FallbackMark()
                    else
                      Image.asset(
                        logo,
                        height: 26,
                        width: 26,
                        fit: BoxFit.contain,
                        // A platform added without artwork still gets a mark
                        // rather than a broken-image box.
                        errorBuilder: (_, _, _) => const _FallbackMark(),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
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
    return const SizedBox(
      height: 26,
      width: 26,
      child: Icon(Icons.podcasts_rounded, size: 22, color: AppColors.ink),
    );
  }
}
