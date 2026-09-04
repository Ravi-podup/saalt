import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Where to listen. Scrolls horizontally so the list can grow.
class PlatformRow extends StatelessWidget {
  const PlatformRow({super.key, required this.platforms, this.onOpen});

  final List<String> platforms;
  final ValueChanged<String>? onOpen;

  static const _glyphs = <String, IconData>{
    'Apple Podcasts': Icons.podcasts_rounded,
    'Spotify': Icons.graphic_eq_rounded,
    'YouTube': Icons.smart_display_rounded,
    'Amazon Music': Icons.library_music_rounded,
    'iHeartRadio': Icons.radio_rounded,
    'Pocket Casts': Icons.headphones_rounded,
    'Overcast': Icons.cloud_rounded,
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
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Icon(
                        _glyphs[name] ?? Icons.podcasts_rounded,
                        size: 22,
                        color: AppColors.ink,
                      ),
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
