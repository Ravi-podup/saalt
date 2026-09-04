import 'package:flutter/material.dart';
import 'package:saalt/models/episode.dart';
import 'package:saalt/res/app_images.dart';

/// Episode artwork. Uses [Episode.imageAsset] when there is real art, and
/// otherwise composes a branded panel from the episode's own colours - which
/// is why every episode has an image even before artwork is shot.
class EpisodeArt extends StatelessWidget {
  const EpisodeArt({
    super.key,
    required this.episode,
    this.showWordmark = false,
    this.borderRadius = 16,
  });

  final Episode episode;

  /// Large surfaces carry the wordmark and episode number; small thumbnails
  /// would only turn them into noise.
  final bool showWordmark;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final asset = episode.imageAsset;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: asset == null
          ? _Generated(episode: episode, showWordmark: showWordmark)
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      _Generated(episode: episode, showWordmark: showWordmark),
                ),
                if (showWordmark) _Overlay(episode: episode),
              ],
            ),
    );
  }
}

/// Wordmark and episode label over the photo, on a scrim so they stay legible
/// whatever the image behind them.
class _Overlay extends StatelessWidget {
  const _Overlay({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0.92),
            Colors.white.withValues(alpha: 0.72),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0, 0.42, 0.78],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(AppImages.logo, height: 15, fit: BoxFit.contain),
            Text(
              'EPISODE-${episode.number} | ${episode.format.toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: episode.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Generated extends StatelessWidget {
  const _Generated({required this.episode, required this.showWordmark});

  final Episode episode;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            episode.tint,
            Color.lerp(episode.tint, episode.accent, 0.38)!,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Soft off-centre bloom, so the panel is not a flat wash.
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.34),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          if (showWordmark)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(AppImages.logo, height: 15, fit: BoxFit.contain),
                  Text(
                    'EPISODE ${episode.number}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: episode.accent,
                    ),
                  ),
                ],
              ),
            )
          else
            Center(
              child: Text(
                '${episode.number}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  color: episode.accent.withValues(alpha: 0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Play glyph laid over episode artwork, so a thumbnail reads as watchable.
class VideoBadge extends StatelessWidget {
  const VideoBadge({super.key, required this.accent, this.size = 34});

  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.play_arrow_rounded, size: size * 0.62, color: accent),
    );
  }
}
