import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saalt/helper/testimonial_helper.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';
import 'package:video_player/video_player.dart';

class ShareStoryScreen extends StatefulWidget {
  const ShareStoryScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.shareStoryScreen);
  }

  @override
  State<ShareStoryScreen> createState() => _ShareStoryScreenState();
}

class _ShareStoryScreenState extends State<ShareStoryScreen> {
  final _caption = TextEditingController();
  final _name = TextEditingController();

  int _rating = 5;
  String? _product;
  bool _firstNameOnly = true;
  bool _consent = false;

  /// The chosen clip, once the camera or the gallery has handed one over.
  XFile? _clip;
  VideoPlayerController? _preview;

  /// True while the picker is open, so the buttons cannot be fired twice.
  bool _picking = false;

  @override
  void dispose() {
    _preview?.dispose();
    _caption.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picked = await ImagePicker().pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 90),
      );
      if (picked == null || !mounted) return;
      await _load(picked);
    } on Exception {
      // exception rather than null; there is nothing to say about it, so the
      // screen simply stays as it was.
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  /// Swaps in a new clip and its preview, disposing whatever was there.
  Future<void> _load(XFile file) async {
    final controller = VideoPlayerController.file(File(file.path));
    await controller.initialize();
    await controller.setLooping(true);
    if (!mounted) {
      await controller.dispose();
      return;
    }
    final old = _preview;
    setState(() {
      _clip = file;
      _preview = controller;
    });
    await old?.dispose();
  }

  Future<void> _clear() async {
    final old = _preview;
    setState(() {
      _clip = null;
      _preview = null;
    });
    await old?.dispose();
  }

  bool get _canSend => _clip != null && _consent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'Share your story',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('share-story-body'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  const Text(
                    'Film a short clip about what changed for you. We publish '
                    'a few every month, and you will hear from us before '
                    'yours goes up.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_clip == null)
                    _ClipBlock(
                      isBusy: _picking,
                      onRecord: () => _pick(ImageSource.camera),
                      onUpload: () => _pick(ImageSource.gallery),
                    )
                  else
                    _ClipPreview(
                      file: _clip!,
                      controller: _preview,
                      onReplace: () => _pick(ImageSource.gallery),
                      onRemove: _clear,
                    ),
                  const SizedBox(height: 14),
                  const _Rules(),
                  const SizedBox(height: 24),
                  const _SectionLabel('What to talk about'),
                  const SizedBox(height: 10),
                  const _Prompts(),
                  const SizedBox(height: 24),
                  const _SectionLabel('Which product'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final name in TestimonialHelper.reviewedProducts)
                        _Chip(
                          label: name,
                          isPicked: _product == name,
                          onTap: () => setState(() => _product = name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('Your rating'),
                  const SizedBox(height: 8),
                  _StarPicker(
                    rating: _rating,
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('A line to go with it'),
                  const SizedBox(height: 9),
                  _Field(
                    hint: 'The one sentence you would lead with',
                    controller: _caption,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('Your name'),
                  const SizedBox(height: 9),
                  _Field(
                    hint: 'How you want to be credited',
                    controller: _name,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 10),
                  _CheckRow(
                    title: 'Show my first name only',
                    isOn: _firstNameOnly,
                    onTap: () =>
                        setState(() => _firstNameOnly = !_firstNameOnly),
                  ),
                  const SizedBox(height: 20),
                  _CheckRow(
                    title: 'Saalt can share this clip',
                    detail:
                        'On the app, the site and social. You can ask us to '
                        'take it down at any time.',
                    isOn: _consent,
                    onTap: () => setState(() => _consent = !_consent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SendBar(canSend: _canSend, onSend: () {}),
    );
  }
}

/// Where the clip comes from: the camera, or something already filmed.
class _ClipBlock extends StatelessWidget {
  const _ClipBlock({
    required this.isBusy,
    required this.onRecord,
    required this.onUpload,
  });

  /// True while a picker is open, so a second tap cannot stack another.
  final bool isBusy;

  final VoidCallback onRecord;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.roseTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_rounded,
              size: 25,
              color: AppColors.rose,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Add your clip',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Film it now, or pick one you already have.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ClipAction(
                  icon: Icons.fiber_manual_record_rounded,
                  label: 'Record',
                  isPrimary: true,
                  isBusy: isBusy,
                  onTap: onRecord,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ClipAction(
                  icon: Icons.photo_library_outlined,
                  label: 'Upload',
                  isBusy: isBusy,
                  onTap: onUpload,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClipAction extends StatelessWidget {
  const _ClipAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isBusy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final ink = isPrimary ? Colors.white : AppColors.ink;

    return Material(
      color: isPrimary ? AppColors.ink : AppColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isPrimary ? AppColors.ink : AppColors.hairline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isBusy)
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: ink),
                )
              else
                Icon(
                  icon,
                  size: isPrimary ? 13 : 16,
                  color: isPrimary ? AppColors.rose : ink,
                ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The chosen clip, playing back where the empty block was. Tapping it
/// starts and stops it; the clip loops so a short one does not just end.
class _ClipPreview extends StatefulWidget {
  const _ClipPreview({
    required this.file,
    required this.controller,
    required this.onReplace,
    required this.onRemove,
  });

  final XFile file;
  final VideoPlayerController? controller;
  final VoidCallback onReplace;
  final VoidCallback onRemove;

  @override
  State<_ClipPreview> createState() => _ClipPreviewState();
}

class _ClipPreviewState extends State<_ClipPreview> {
  /// Every clip previews at this height, whatever shape it was filmed in.
  static const _frameHeight = 260.0;

  void _toggle() {
    final controller = widget.controller;
    if (controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isReady = controller != null && controller.value.isInitialized;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: SizedBox(
              // A fixed frame, not the clip's own shape: a phone-shot
              // portrait video is 16:9 on its side and would run about 680
              // tall here, while a landscape one comes in at barely 200. The
              // card has to be the same size either way.
              height: _frameHeight,
              width: double.infinity,
              child: GestureDetector(
                onTap: _toggle,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isReady)
                      // Cropped to fill rather than letterboxed, so a
                      // portrait clip does not sit in a pillarbox.
                      FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      )
                    else
                      const ColoredBox(color: AppColors.roseTint),
                    if (!isReady)
                      const Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.rose,
                          ),
                        ),
                      )
                    else if (!controller.value.isPlaying)
                      Center(
                        child: Container(
                          height: 52,
                          width: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.ink.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.movie_outlined,
                  size: 16,
                  color: AppColors.inkFaint,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isReady
                            ? _clipLength(controller.value.duration)
                            : 'Reading the clip...',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.inkFaint,
                        ),
                      ),
                    ],
                  ),
                ),
                _SmallAction(label: 'Replace', onTap: widget.onReplace),
                _SmallAction(label: 'Remove', onTap: widget.onRemove),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A clip's length as people say it: "1:04", not "64 seconds".
  static String _clipLength(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.rose,
            ),
          ),
        ),
      ),
    );
  }
}

/// What we ask of a clip, so nobody films three minutes and has it bounce.
class _Rules extends StatelessWidget {
  const _Rules();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: [
        for (final rule in TestimonialHelper.clipRules)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(rule.icon, size: 13, color: AppColors.inkFaint),
              const SizedBox(width: 5),
              Text(
                rule.text,
                style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
              ),
            ],
          ),
      ],
    );
  }
}

/// Three questions to answer on camera. A blank lens is the hardest part.
class _Prompts extends StatelessWidget {
  const _Prompts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < TestimonialHelper.prompts.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(13, 12, 14, 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.roseTint,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.rose,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      TestimonialHelper.prompts[i],
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Five stars you can actually set, unlike the read-only one on the cards.
class _StarPicker extends StatelessWidget {
  const _StarPicker({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var star = 1; star <= 5; star++)
          Semantics(
            button: true,
            selected: star <= rating,
            label: '$star ${star == 1 ? 'star' : 'stars'}',
            child: InkWell(
              onTap: () => onChanged(star),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Icon(
                  star <= rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 30,
                  color: star <= rating ? AppColors.rose : AppColors.inkFaint,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.inkFaint,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isPicked,
    required this.onTap,
  });

  final String label;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPicked ? AppColors.rose : AppColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isPicked ? AppColors.rose : AppColors.hairline,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPicked ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.hint,
    required this.controller,
    this.icon,
    this.maxLines = 1,
  });

  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkFaint),
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 18, color: AppColors.inkFaint),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.title,
    this.detail,
    required this.isOn,
    required this.onTap,
  });

  final String title;
  final String? detail;
  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isOn ? AppColors.rose : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isOn ? AppColors.rose : AppColors.inkFaint,
                ),
              ),
              child: isOn
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      detail!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What happens next, and the button that does it.
class _SendBar extends StatelessWidget {
  const _SendBar({required this.canSend, required this.onSend});

  /// A clip and consent are the two things a video testimonial cannot go
  /// without. The button stays live either way — it just says what is
  /// missing rather than going grey.
  final bool canSend;

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: onSend,
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 15, color: Colors.white),
                        SizedBox(width: 9),
                        Text(
                          'Send it in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                canSend
                    ? 'We review every clip before it appears.'
                    : 'Add a clip and tick the sharing box to send.',
                style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
