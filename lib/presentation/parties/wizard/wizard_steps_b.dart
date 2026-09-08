import 'package:flutter/material.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/wizard/wizard_widgets.dart';
import 'package:saalt/res/app_colors.dart';

/// Step 3. Audience switcher, the mails that go out, and a preview.
class EmailsStep extends StatefulWidget {
  const EmailsStep({super.key, required this.draft, required this.onChanged});

  final WebinarDraft draft;
  final VoidCallback onChanged;

  @override
  State<EmailsStep> createState() => _EmailsStepState();
}

class _EmailsStepState extends State<EmailsStep> {
  bool _forSpeakers = true;

  Map<String, bool> get _mails =>
      _forSpeakers ? widget.draft.speakerEmails : widget.draft.attendeeEmails;

  static const _details = <String, String>{
    'Invitation email': 'Sent when a speaker is added to this webinar.',
    'Reminder email': 'Sent shortly before the webinar starts.',
    'Invite email': 'Sent to attendees when you add them.',
    'Registration confirmation': 'Sent to attendees after they register.',
  };

  @override
  Widget build(BuildContext context) {
    final speakerOn = widget.draft.speakerEmails.values.where((v) => v).length;
    final attendeeOn = widget.draft.attendeeEmails.values
        .where((v) => v)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _AudienceCard(
                label: 'Speakers',
                detail: 'Hosts, presenters & panelists',
                icon: Icons.record_voice_over_rounded,
                count: speakerOn,
                isActive: _forSpeakers,
                onTap: () => setState(() => _forSpeakers = true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AudienceCard(
                label: 'Attendees',
                detail: 'People who register to watch',
                icon: Icons.groups_2_rounded,
                count: attendeeOn,
                isActive: !_forSpeakers,
                onTap: () => setState(() => _forSpeakers = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final entry in _mails.entries) ...[
          WizardCard(
            children: [
              ToggleRow(
                dotColor: entry.value ? AppColors.sage : AppColors.hairline,
                label: entry.key,
                detail: _details[entry.key] ?? '',
                value: entry.value,
                onChanged: (value) {
                  setState(() => _mails[entry.key] = value);
                  widget.onChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        WizardSection(
          title: 'Live preview',
          detail: 'Sample data filled in.',
          trailing: SparkLink(label: 'Edit copy', onTap: null),
          children: [
            _MailPreview(
              kind: _forSpeakers ? 'SPEAKER INVITATION' : 'ATTENDEE INVITE',
              headline: _forSpeakers
                  ? 'You are a featured speaker'
                  : 'You are invited'
                        '',
              body: _forSpeakers
                  ? 'We are glad to have you lead this session. Your slot and '
                        'materials are in your speaker portal.'
                  : 'Join us for a live TMI Party. Places are limited, so '
                        'register while there is room.',
              cta: _forSpeakers ? 'Join webinar' : 'Register now — it is free',
              title: widget.draft.title.trim().isEmpty
                  ? 'Your webinar title'
                  : widget.draft.title.trim(),
            ),
          ],
        ),
      ],
    );
  }
}

class _AudienceCard extends StatelessWidget {
  const _AudienceCard({
    required this.label,
    required this.detail,
    required this.icon,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final String detail;
  final IconData icon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.roseTint : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? AppColors.rose : AppColors.hairline,
                width: isActive ? 1.6 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 17,
                      color: isActive ? AppColors.rose : AppColors.inkMuted,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sageTint,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '$count on',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.sage,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.3,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MailPreview extends StatelessWidget {
  const _MailPreview({
    required this.kind,
    required this.headline,
    required this.body,
    required this.cta,
    required this.title,
  });

  final String kind;
  final String headline;
  final String body;
  final String cta;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 13,
                  color: AppColors.inkFaint,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    kind,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    cta,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.inkMuted,
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

/// Step 4. Artwork sized per platform, with the console's control groups.
class ThumbnailStep extends StatefulWidget {
  const ThumbnailStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final WebinarDraft draft;
  final VoidCallback onChanged;

  @override
  State<ThumbnailStep> createState() => _ThumbnailStepState();
}

class _ThumbnailStepState extends State<ThumbnailStep> {
  /// Local to the step: these are preview filters, not part of the draft a
  /// card is built from.
  final _adjustments = <String, double>{
    'Brightness': 100,
    'Contrast': 100,
    'Saturation': 100,
  };

  WebinarDraft get draft => widget.draft;

  void onChanged() => widget.onChanged();

  static const _platforms = <({String label, String size})>[
    (label: 'Webinar', size: '1280 × 720'),
    (label: 'Instagram', size: '1080 × 1080'),
    (label: 'LinkedIn', size: '1200 × 628'),
    (label: 'X', size: '1600 × 900'),
    (label: 'Facebook', size: '1200 × 630'),
  ];

  @override
  Widget build(BuildContext context) {
    final platform = _platforms.firstWhere(
      (p) => p.label == draft.thumbnailPlatform,
      orElse: () => _platforms.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final p in _platforms) ...[
                _PlatformChip(
                  label: p.label,
                  size: p.size,
                  isActive: p.label == draft.thumbnailPlatform,
                  onTap: () {
                    draft.thumbnailPlatform = p.label;
                    onChanged();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        WizardCard(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Preview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Text(
                  '${platform.label} · ${platform.size}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A5468), AppColors.primaryColor],
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: draft.textPosition == 'Top'
                          ? Alignment.topLeft
                          : draft.textPosition == 'Middle'
                          ? Alignment.centerLeft
                          : Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          draft.title.trim().isEmpty
                              ? 'Your title here'
                              : draft.title.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13 * (draft.titleSize / 100),
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MiniButton(
                    label: 'Download',
                    icon: Icons.download_rounded,
                    onTap: null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniButton(
                    label: 'Save image',
                    icon: Icons.save_alt_rounded,
                    onTap: null,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Background & zoom',
          detail: 'Add a background, then frame it.',
          trailing: SparkLink(
            label: 'Reset',
            onTap: () {
              draft.zoom = 1.75;
              onChanged();
            },
          ),
          children: [
            WizardCard(
              children: [
                UploadBox(
                  label: 'Add a background',
                  detail: 'Or generate one',
                  icon: Icons.image_outlined,
                  height: 96,
                  onTap: null,
                ),
                const SizedBox(height: 12),
                SliderRow(
                  label: 'Zoom',
                  value: draft.zoom,
                  min: 1,
                  max: 3,
                  display: '${draft.zoom.toStringAsFixed(2)}x',
                  onChanged: (value) {
                    draft.zoom = value;
                    onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Text & layout',
          detail: 'How the title sits on the artwork.',
          children: [
            WizardCard(
              children: [
                SliderRow(
                  label: 'Title size',
                  value: draft.titleSize,
                  min: 60,
                  max: 140,
                  display: '${draft.titleSize.round()}%',
                  onChanged: (value) {
                    draft.titleSize = value;
                    onChanged();
                  },
                ),
                const SizedBox(height: 4),
                const FieldLabel('Position'),
                PillGroup(
                  options: const ['Top', 'Middle', 'Bottom'],
                  selected: draft.textPosition,
                  onChanged: (value) {
                    draft.textPosition = value;
                    onChanged();
                  },
                ),
                const CardDivider(),
                const FieldLabel('Style'),
                PillGroup(
                  options: const ['Dark', 'Light', 'Rose', 'None'],
                  selected: draft.textStyle,
                  onChanged: (value) {
                    draft.textStyle = value;
                    onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Image adjustments',
          detail: 'The console keeps these on hand for stills.',
          children: [
            WizardCard(
              children: [
                for (final label in const [
                  'Brightness',
                  'Contrast',
                  'Saturation',
                ])
                  SliderRow(
                    label: label,
                    value: _adjustments[label] ?? 100,
                    min: 0,
                    max: 200,
                    display: '${(_adjustments[label] ?? 100).round()}',
                    onChanged: (value) =>
                        setState(() => _adjustments[label] = value),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({
    required this.label,
    required this.size,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final String size;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.ink : AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppColors.ink : AppColors.hairline,
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.inkMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  size,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: AppColors.hairline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: onTap == null ? AppColors.inkFaint : AppColors.ink,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: onTap == null ? AppColors.inkFaint : AppColors.ink,
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
