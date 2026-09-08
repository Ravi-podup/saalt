import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/session_look.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/wizard/brief_screen.dart';
import 'package:saalt/presentation/parties/wizard/wizard_widgets.dart';
import 'package:saalt/res/app_colors.dart';

/// Step 1. Everything an attendee eventually reads on the card.
class SetupStep extends StatefulWidget {
  const SetupStep({
    super.key,
    required this.draft,
    required this.onChanged,
    this.showRequirements = false,
  });

  final WebinarDraft draft;
  final VoidCallback onChanged;

  /// Shown after Finish was refused for a missing title or schedule.
  final bool showRequirements;

  @override
  State<SetupStep> createState() => _SetupStepState();
}

class _SetupStepState extends State<SetupStep> {
  late final _title = TextEditingController(text: widget.draft.title);
  late final _description = TextEditingController(
    text: widget.draft.description,
  );
  late final _objectives = [
    for (final objective in widget.draft.objectives)
      TextEditingController(text: objective),
  ];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    for (final controller in _objectives) {
      controller.dispose();
    }
    super.dispose();
  }

  WebinarDraft get _draft => widget.draft;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      _draft.date = picked;
      widget.onChanged();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _draft.time ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) {
      _draft.time = picked;
      widget.onChanged();
    }
  }

  /// The brief is its own screen; on the way back the fields it filled are
  /// reflected in the controllers.
  Future<void> _openBrief() async {
    final used = await BriefScreen.open(context, draft: _draft);
    if (used != true || !mounted) return;
    setState(() {
      _description.text = _draft.description;
      _objectives[0].text = _draft.objectives.first;
    });
    widget.onChanged();
  }

  void _addObjective() {
    if (_objectives.length >= 5) return;
    setState(() {
      _draft.objectives.add('');
      _objectives.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final startsAt = _draft.startsAt;
    final isPast = startsAt != null && !startsAt.isAfter(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showRequirements && !_draft.canFinish) ...[
          const NoticeStrip(
            message: 'Add a title and a schedule before finishing.',
          ),
          const SizedBox(height: 16),
        ],
        _BriefCard(draft: _draft, onOpen: _openBrief),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Basic information',
          detail: 'Tell us about your webinar.',
          children: [
            WizardCard(
              children: [
                const FieldLabel('Webinar schedule'),
                ChoiceCards(
                  options: const [
                    (
                      label: 'Scheduled',
                      detail: 'Set date & time',
                      icon: Icons.event_rounded,
                    ),
                    (
                      label: 'Immediately',
                      detail: 'Open now',
                      icon: Icons.videocam_rounded,
                    ),
                  ],
                  selected: _draft.startsImmediately
                      ? 'Immediately'
                      : 'Scheduled',
                  onChanged: (value) {
                    _draft.startsImmediately = value == 'Immediately';
                    widget.onChanged();
                  },
                ),
                if (!_draft.startsImmediately) ...[
                  const CardDivider(),
                  const FieldLabel('Date & time', isRequired: true),
                  Row(
                    children: [
                      Expanded(
                        child: _PickerBox(
                          icon: Icons.event_rounded,
                          value: _draft.date == null
                              ? 'Pick a date'
                              : DateLabels.weekdayDayMonth(_draft.date!),
                          isSet: _draft.date != null,
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PickerBox(
                          icon: Icons.schedule_rounded,
                          value: _draft.time == null
                              ? 'Pick a time'
                              : DateLabels.time(
                                  DateTime(
                                    2026,
                                    1,
                                    1,
                                    _draft.time!.hour,
                                    _draft.time!.minute,
                                  ),
                                ),
                          isSet: _draft.time != null,
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const FieldLabel('Time zone'),
                  _PickerBox(
                    icon: Icons.public_rounded,
                    value: _draft.timeZone,
                    isSet: true,
                    onTap: null,
                  ),
                  if (isPast) ...[
                    const SizedBox(height: 10),
                    const NoticeStrip(
                      message:
                          'You cannot create a webinar in a past date '
                          'and time.',
                    ),
                  ] else if (startsAt != null) ...[
                    const SizedBox(height: 10),
                    NoticeStrip(
                      tone: NoticeTone.good,
                      message:
                          'Local time '
                          '${DateLabels.weekdayDayMonth(startsAt)} at '
                          '${DateLabels.time(startsAt)}.',
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 12),
            WizardCard(
              children: [
                FieldLabel(
                  'Webinar title',
                  isRequired: true,
                  action: SparkLink(label: 'Suggest titles', onTap: null),
                ),
                WizardInput(
                  controller: _title,
                  hint: 'e.g. Cups: your first one, start to finish',
                  maxLength: 90,
                  onChanged: (value) {
                    _draft.title = value;
                    widget.onChanged();
                  },
                ),
                const CardDivider(),
                FieldLabel(
                  'Learning objectives',
                  action: SparkLink(label: 'Suggest objectives', onTap: null),
                ),
                for (var i = 0; i < _objectives.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: WizardInput(
                          controller: _objectives[i],
                          hint: 'What will attendees learn?',
                          maxLength: 90,
                          onChanged: (value) => _draft.objectives[i] = value,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                _AddRow(label: 'Add another objective', onTap: _addObjective),
                const CardDivider(),
                FieldLabel(
                  'Full description',
                  isRequired: true,
                  action: SparkLink(label: 'Write description', onTap: null),
                ),
                const _FormatBar(),
                const SizedBox(height: 8),
                WizardInput(
                  controller: _description,
                  hint: 'Detailed description of your webinar.',
                  maxLines: 5,
                  maxLength: 2000,
                  onChanged: (value) {
                    _draft.description = value;
                    widget.onChanged();
                  },
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_description.text.length} / 2000 characters',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Branding & media',
          detail: 'Artwork and the logo attendees see.',
          children: [
            WizardCard(
              children: [
                const FieldLabel('Company logo'),
                UploadBox(
                  label: 'Upload company logo',
                  detail: 'PNG or JPG',
                  icon: Icons.apartment_rounded,
                  onTap: null,
                ),
                const CardDivider(),
                const FieldLabel('Card look'),
                const Text(
                  'Used for the cover until a still is uploaded.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.4,
                    color: AppColors.inkFaint,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final look in sessionLooks)
                      _LookOption(
                        look: look,
                        isActive: look.label == _draft.look.label,
                        onTap: () {
                          _draft.look = look;
                          widget.onChanged();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Webinar settings',
          detail: 'How the room runs.',
          children: [
            WizardCard(
              children: [
                const FieldLabel('Webinar plan', isRequired: true),
                ChoiceCards(
                  options: const [
                    (
                      label: 'Free',
                      detail: 'Open to all',
                      icon: Icons.card_giftcard_rounded,
                    ),
                    (
                      label: 'Paid',
                      detail: 'Ticketed',
                      icon: Icons.payments_rounded,
                    ),
                  ],
                  selected: _draft.isPaid ? 'Paid' : 'Free',
                  onChanged: (value) {
                    _draft.isPaid = value == 'Paid';
                    widget.onChanged();
                  },
                ),
                if (_draft.isPaid) ...[
                  const SizedBox(height: 10),
                  const NoticeStrip(
                    tone: NoticeTone.info,
                    message:
                        'Ticket prices and payouts are set up in the '
                        'console, not here.',
                  ),
                ],
                const CardDivider(),
                const FieldLabel('Webinar type', isRequired: true),
                ChoiceCards(
                  options: const [
                    (
                      label: 'Live',
                      detail: 'Real-time event',
                      icon: Icons.sensors_rounded,
                    ),
                    (
                      label: 'On-demand',
                      detail: 'Pre-recorded',
                      icon: Icons.play_circle_outline_rounded,
                    ),
                  ],
                  selected: _draft.isLive ? 'Live' : 'On-demand',
                  onChanged: (value) {
                    _draft.isLive = value == 'Live';
                    widget.onChanged();
                  },
                ),
                const CardDivider(),
                const FieldLabel('Duration', isRequired: true),
                PillGroup(
                  options: [
                    for (final d in WebinarDraft.durations)
                      DateLabels.duration(d),
                  ],
                  selected: DateLabels.duration(_draft.minutes),
                  onChanged: (value) {
                    _draft.minutes = WebinarDraft.durations.firstWhere(
                      (d) => DateLabels.duration(d) == value,
                    );
                    widget.onChanged();
                  },
                ),
                const CardDivider(),
                const FieldLabel('Language', isRequired: true),
                PillGroup(
                  options: WebinarDraft.languages,
                  selected: _draft.language,
                  onChanged: (value) {
                    _draft.language = value;
                    widget.onChanged();
                  },
                ),
                const CardDivider(),
                const FieldLabel('Expected audience size'),
                PillGroup(
                  options: WebinarDraft.audienceSizes,
                  selected: _draft.audience,
                  onChanged: (value) {
                    _draft.audience = value;
                    widget.onChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            WizardCard(
              children: [
                ToggleRow(
                  label: 'Require approval for registration',
                  detail: 'Manually approve each attendee.',
                  value: _draft.requiresApproval,
                  onChanged: (value) {
                    _draft.requiresApproval = value;
                    widget.onChanged();
                  },
                ),
                const CardDivider(),
                ToggleRow(
                  label: 'Enable waiting room',
                  detail: 'Hold attendees in the lobby until you admit them.',
                  value: _draft.hasWaitingRoom,
                  onChanged: (value) {
                    _draft.hasWaitingRoom = value;
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Additional information',
          detail: 'Optional extras that make the session more useful.',
          children: [
            WizardCard(
              children: [
                const FieldLabel('Attendee benefits & resources'),
                UploadBox(
                  label: 'Upload slides, handouts or resources',
                  detail: 'PDF, PPTX or DOCX',
                  icon: Icons.cloud_upload_rounded,
                  onTap: null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LookOption extends StatelessWidget {
  const _LookOption({
    required this.look,
    required this.isActive,
    required this.onTap,
  });

  final SessionLook look;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: look.label,
      child: Material(
        color: look.tint,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? look.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(look.icon, size: 21, color: look.accent),
          ),
        ),
      ),
    );
  }
}

/// Entry point for the brief. Compact on purpose: the form behind it is long,
/// and this step is long enough already.
class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.draft, required this.onOpen});

  final WebinarDraft draft;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.roseTint,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: const BoxDecoration(
                      color: AppColors.rose,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.hasBrief ? 'Brief added' : 'Start with a brief',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          draft.hasBrief
                              ? 'Tap to change what you wrote.'
                              : 'Describe the session in a sentence and we '
                                    'fill in what we can.',
                          style: const TextStyle(
                            fontSize: 10.5,
                            height: 1.4,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.rose,
                  ),
                ],
              ),
              if (draft.briefTags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in draft.briefTags)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.rose,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  const _PickerBox({
    required this.icon,
    required this.value,
    required this.isSet,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final bool isSet;

  /// Null shows the value without inviting a tap, which is what the time
  /// zone is until there is a picker behind it.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: AppColors.inkFaint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSet ? AppColors.ink : AppColors.inkFaint,
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

/// The rich-text strip from the console. Decorative here.
class _FormatBar extends StatelessWidget {
  const _FormatBar();

  @override
  Widget build(BuildContext context) {
    const glyphs = [
      Icons.format_bold_rounded,
      Icons.format_italic_rounded,
      Icons.format_underlined_rounded,
      Icons.strikethrough_s_rounded,
      Icons.format_list_numbered_rounded,
      Icons.format_list_bulleted_rounded,
      Icons.link_rounded,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          for (final glyph in glyphs)
            Expanded(
              child: SizedBox(
                height: 28,
                child: Icon(glyph, size: 15, color: AppColors.inkFaint),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({required this.label, required this.onTap});

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
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 15, color: AppColors.rose),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.rose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Step 2. The console asks first, then shows the form.
class SpeakersStep extends StatefulWidget {
  const SpeakersStep({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onSkip,
  });

  final WebinarDraft draft;
  final VoidCallback onChanged;
  final VoidCallback onSkip;

  @override
  State<SpeakersStep> createState() => _SpeakersStepState();
}

class _SpeakersStepState extends State<SpeakersStep> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _jobTitle = TextEditingController();
  final _company = TextEditingController();
  final _bio = TextEditingController();

  bool _isAdding = false;
  SpeakerRole _role = SpeakerRole.host;
  late Map<String, bool> _permissions = {...SpeakerRole.host.permissions};

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _jobTitle.dispose();
    _company.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _pickRole(SpeakerRole role) {
    setState(() {
      _role = role;
      _permissions = {...role.permissions};
    });
  }

  void _save() {
    widget.draft.speakers.add(
      SpeakerDraft(
        firstName: _first.text.trim(),
        lastName: _last.text.trim(),
        email: _email.text.trim(),
        jobTitle: _jobTitle.text.trim(),
        company: _company.text.trim(),
        role: _role,
      ),
    );
    _first.clear();
    _last.clear();
    _email.clear();
    _jobTitle.clear();
    _company.clear();
    _bio.clear();
    setState(() => _isAdding = false);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final speakers = widget.draft.speakers;

    if (!_isAdding) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (speakers.isEmpty)
            _AskCard(
              onAdd: () => setState(() => _isAdding = true),
              onSkip: widget.onSkip,
            )
          else ...[
            for (final speaker in speakers) ...[
              _SpeakerRow(
                speaker: speaker,
                onRemove: () {
                  setState(() => speakers.remove(speaker));
                  widget.onChanged();
                },
              ),
              const SizedBox(height: 10),
            ],
            _AddRow(
              label: 'Add another speaker',
              onTap: () => setState(() => _isAdding = true),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSection(
          title: 'Add a speaker',
          detail: 'The details attendees see on the webinar page.',
          children: [
            WizardCard(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('First name', isRequired: true),
                          WizardInput(
                            controller: _first,
                            hint: 'First name',
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('Last name'),
                          WizardInput(controller: _last, hint: 'Last name'),
                        ],
                      ),
                    ),
                  ],
                ),
                const CardDivider(),
                const FieldLabel('Email address', isRequired: true),
                WizardInput(
                  controller: _email,
                  hint: 'name@company.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 6),
                const Text(
                  'An invitation to join the webinar goes here.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
                ),
                const CardDivider(),
                const FieldLabel('Job title'),
                WizardInput(
                  controller: _jobTitle,
                  hint: 'e.g. Pelvic health physiotherapist',
                ),
                const SizedBox(height: 10),
                const FieldLabel('Company or organisation'),
                WizardInput(controller: _company, hint: 'Company name'),
                const CardDivider(),
                const FieldLabel('Speaker bio'),
                WizardInput(
                  controller: _bio,
                  hint: 'A short professional biography.',
                  maxLines: 4,
                  maxLength: 500,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Shown on the registration page.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
                ),
                const CardDivider(),
                const FieldLabel('Profile photo'),
                UploadBox(
                  label: 'Upload profile photo',
                  detail: 'PNG or JPG, 400×400 recommended',
                  icon: Icons.photo_camera_rounded,
                  height: 112,
                  onTap: null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            WizardCard(
              children: [
                const FieldLabel('Speaker role', isRequired: true),
                Column(
                  children: [
                    for (final role in SpeakerRole.values) ...[
                      if (role != SpeakerRole.values.first)
                        const SizedBox(height: 8),
                      _RoleRow(
                        role: role,
                        isActive: role == _role,
                        onTap: () => _pickRole(role),
                      ),
                    ],
                  ],
                ),
                const CardDivider(),
                const FieldLabel('Permissions for this role'),
                const Text(
                  'Defaults come with the role. Override any of them before '
                  'saving.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.4,
                    color: AppColors.inkFaint,
                  ),
                ),
                const SizedBox(height: 10),
                for (final entry in _permissions.entries)
                  _PermissionRow(
                    label: entry.key,
                    value: entry.value,
                    onChanged: (value) =>
                        setState(() => _permissions[entry.key] = value),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _OutlineButton(
                    label: 'Cancel',
                    onTap: () => setState(() => _isAdding = false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _FilledButton(
                    label: 'Save speaker',
                    // Disabled rather than refused: a name is the one thing
                    // a speaker row cannot do without.
                    onTap: _first.text.trim().isEmpty ? null : _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _AskCard extends StatelessWidget {
  const _AskCard({required this.onAdd, required this.onSkip});

  final VoidCallback onAdd;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return WizardCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: const Icon(
                  Icons.groups_2_rounded,
                  size: 26,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you want to add speakers?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Speakers are the hosts, presenters or panelists who will '
                'join. Add them now, or skip to email settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 18),
              _FilledButton(
                label: 'Yes, add a speaker',
                icon: Icons.person_add_alt_rounded,
                onTap: onAdd,
              ),
              const SizedBox(height: 10),
              _OutlineButton(label: 'No, continue', onTap: onSkip),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpeakerRow extends StatelessWidget {
  const _SpeakerRow({required this.speaker, required this.onRemove});

  final SpeakerDraft speaker;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return WizardCard(
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.roseTint,
                shape: BoxShape.circle,
              ),
              child: Text(
                speaker.firstName.isEmpty
                    ? '?'
                    : speaker.firstName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.rose,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    speaker.name.isEmpty ? 'Unnamed speaker' : speaker.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      speaker.role.label,
                      if (speaker.jobTitle.isNotEmpty) speaker.jobTitle,
                      if (speaker.company.isNotEmpty) speaker.company,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              tooltip: 'Remove ${speaker.name}',
              icon: const Icon(Icons.close_rounded, color: AppColors.inkFaint),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.role,
    required this.isActive,
    required this.onTap,
  });

  final SpeakerRole role;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.roseTint : AppColors.canvas,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? AppColors.rose : AppColors.hairline,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  role.icon,
                  size: 17,
                  color: isActive ? AppColors.rose : AppColors.inkMuted,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    role.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Text(
                  role.detail,
                  style: const TextStyle(
                    fontSize: 10.5,
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

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: const WidgetStatePropertyAll(Colors.white),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.rose
                : AppColors.hairline,
          ),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ],
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.label, this.onTap, this.icon});

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: onTap == null ? AppColors.hairline : AppColors.ink,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15,
                    color: onTap == null ? AppColors.inkFaint : Colors.white,
                  ),
                  const SizedBox(width: 7),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: onTap == null ? AppColors.inkFaint : Colors.white,
                    ),
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

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.ink, width: 1.3),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
