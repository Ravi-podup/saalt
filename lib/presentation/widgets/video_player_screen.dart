import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Full-screen playback for any clip, opened as its own route. Shared by the
/// show and the video testimonials.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  static const kTitle = 'title';
  static const kSubtitle = 'subtitle';
  static const kUrl = 'url';

  static Future open(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String url,
  }) {
    return context.push(
      AppRoutePaths.videoPlayerScreen,
      extra: {kTitle: title, kSubtitle: subtitle, kUrl: url},
    );
  }

  final String title;
  final String subtitle;

  /// Null means there is nothing to play yet.
  final String? url;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  String? _error;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final url = widget.url;
    if (url == null) {
      setState(() => _error = 'This video is not available yet.');
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      await controller.play();
    } catch (e) {
      await controller.dispose();
      if (!mounted) return;
      setState(() => _error = 'Could not load this video.');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _TitleBar(
              title: widget.title,
              subtitle: widget.subtitle,
              onClose: () => context.pop(),
            ),
            Expanded(
              child: Center(
                child: _error != null
                    ? _ErrorState(message: _error!, onRetry: _retry)
                    : _controller == null
                    ? const _Loading()
                    : GestureDetector(
                        onTap: () =>
                            setState(() => _showControls = !_showControls),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              VideoPlayer(_controller!),
                              if (_showControls)
                                _Controls(
                                  controller: _controller!,
                                  onTogglePlay: _togglePlay,
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retry() {
    setState(() => _error = null);
    _load();
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title, required this.subtitle, this.onClose});

  final String title;
  final String subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            tooltip: 'Close',
            icon: const Icon(
              Icons.close_rounded,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(AppColors.roseTint),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Buffering…',
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videocam_off_rounded,
            size: 34,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                child: Text(
                  'Try again',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.controller, required this.onTogglePlay});

  final VideoPlayerController controller;
  final VoidCallback onTogglePlay;

  String _clock(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$sec' : '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.28),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.62),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onTogglePlay,
                    customBorder: const CircleBorder(),
                    child: SizedBox(
                      height: 58,
                      width: 58,
                      child: Icon(
                        value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 32,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: Column(
                  children: [
                    VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      colors: VideoProgressColors(
                        playedColor: AppColors.rose,
                        bufferedColor: Colors.white.withValues(alpha: 0.4),
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _clock(value.position),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _clock(value.duration),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
