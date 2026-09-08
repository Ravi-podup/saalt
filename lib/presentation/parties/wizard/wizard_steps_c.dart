import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/wizard/webinar_wizard_screen.dart';
import 'package:saalt/presentation/parties/wizard/wizard_widgets.dart';
import 'package:saalt/res/app_colors.dart';

/// Step 5. Everything the draft says, in the shape the card will take.
class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key, required this.draft, required this.onEdit});

  final WebinarDraft draft;

  /// Jumps back to the step that owns a section.
  final ValueChanged<WizardStep> onEdit;

  @override
  Widget build(BuildContext context) {
    final startsAt = draft.startsAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardCard(
          children: [
            Row(
              children: [
                Container(
                  height: 62,
                  width: 82,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 20,
                    color: AppColors.inkFaint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _Badge(label: draft.isLive ? 'LIVE' : 'ON DEMAND'),
                          _Badge(label: draft.isPaid ? 'PAID' : 'FREE'),
                          _Badge(label: draft.language.toUpperCase()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        draft.title.trim().isEmpty
                            ? 'Untitled webinar'
                            : draft.title.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        WizardSection(
          title: 'Session details',
          detail: 'Schedule, type, plan and registration.',
          trailing: SparkLink(
            label: 'Edit',
            onTap: () => onEdit(WizardStep.setup),
          ),
          children: [
            WizardCard(
              children: [
                _Facts(
                  facts: [
                    (
                      'Schedule',
                      draft.startsImmediately
                          ? 'Opens immediately'
                          : startsAt == null
                          ? 'Not set'
                          : '${DateLabels.weekdayDayMonth(startsAt)}, '
                                '${DateLabels.time(startsAt)}',
                    ),
                    ('Type', draft.isLive ? 'Live' : 'On-demand'),
                    ('Plan', draft.isPaid ? 'Paid' : 'Free'),
                    ('Duration', DateLabels.duration(draft.minutes)),
                    ('Language', draft.language),
                    ('Expected attendees', draft.audience),
                  ],
                ),
                const CardDivider(),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Flag(
                      label: draft.requiresApproval
                          ? 'Approval required'
                          : 'Open registration',
                      isGood: !draft.requiresApproval,
                    ),
                    _Flag(
                      label: draft.hasWaitingRoom
                          ? 'Waiting room on'
                          : 'No waiting room',
                      isGood: !draft.hasWaitingRoom,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        WizardSection(
          title: 'About this webinar',
          detail: 'The description attendees read.',
          trailing: SparkLink(
            label: 'Edit',
            onTap: () => onEdit(WizardStep.setup),
          ),
          children: [
            WizardCard(
              children: [
                Text(
                  draft.description.trim().isEmpty
                      ? 'No description yet.'
                      : draft.description.trim(),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: draft.description.trim().isEmpty
                        ? AppColors.inkFaint
                        : AppColors.inkMuted,
                  ),
                ),
                if (draft.objectives.any((o) => o.trim().isNotEmpty)) ...[
                  const CardDivider(),
                  const FieldLabel('What attendees learn'),
                  for (final objective in draft.objectives)
                    if (objective.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: AppColors.sage,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                objective.trim(),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  height: 1.45,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        WizardSection(
          title: 'Meet the speakers',
          detail: '${draft.speakers.length} added.',
          trailing: SparkLink(
            label: 'Add',
            onTap: () => onEdit(WizardStep.speakers),
          ),
          children: [
            WizardCard(
              children: [
                if (draft.speakers.isEmpty)
                  const Text(
                    'No speakers added yet.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.inkFaint,
                    ),
                  )
                else
                  for (final speaker in draft.speakers)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 15,
                            color: AppColors.inkFaint,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              '${speaker.name} · ${speaker.role.label}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        WizardSection(
          title: 'Email notifications',
          detail:
              '${draft.speakerEmails.values.where((v) => v).length + draft.attendeeEmails.values.where((v) => v).length} '
              'of ${draft.speakerEmails.length + draft.attendeeEmails.length} '
              'enabled.',
          trailing: SparkLink(
            label: 'Edit',
            onTap: () => onEdit(WizardStep.emails),
          ),
          children: [
            WizardCard(
              children: [
                for (final entry in {
                  ...draft.speakerEmails,
                  ...draft.attendeeEmails,
                }.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                            color: entry.value
                                ? AppColors.sage
                                : AppColors.hairline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            entry.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Text(
                          entry.value ? 'On' : 'Off',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: entry.value
                                ? AppColors.sage
                                : AppColors.inkFaint,
                          ),
                        ),
                      ],
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.facts});

  final List<(String, String)> facts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final fact in facts)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 108,
                  child: Text(
                    fact.$1.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fact.$2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({required this.label, required this.isGood});

  final String label;
  final bool isGood;

  @override
  Widget build(BuildContext context) {
    final tone = isGood ? AppColors.sage : AppColors.periwinkle;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isGood ? AppColors.sageTint : AppColors.periwinkleTint,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: tone,
        ),
      ),
    );
  }
}

/// Step 6. Draft posts for each place this gets announced.
class SocialStep extends StatelessWidget {
  const SocialStep({super.key});

  static const _channels = <({String label, IconData icon, String blurb})>[
    (
      label: 'Instagram',
      icon: Icons.camera_alt_rounded,
      blurb: 'A square card and a caption for the grid.',
    ),
    (
      label: 'LinkedIn',
      icon: Icons.work_outline_rounded,
      blurb: 'A longer post for the professional feed.',
    ),
    (
      label: 'X',
      icon: Icons.close_rounded,
      blurb: 'One line and the registration link.',
    ),
    (
      label: 'Facebook',
      icon: Icons.groups_rounded,
      blurb: 'An event post for the page.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NoticeStrip(
          tone: NoticeTone.info,
          message:
              'Posting is design only in this build. Copy is drafted '
              'here, then shared from the console.',
        ),
        const SizedBox(height: 16),
        for (final channel in _channels) ...[
          WizardCard(
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Icon(
                      channel.icon,
                      size: 17,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          channel.blurb,
                          style: const TextStyle(
                            fontSize: 10.5,
                            height: 1.35,
                            color: AppColors.inkFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SparkLink(label: 'Draft', onTap: null),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// Step 7. Connected destinations, with the console's health states.
class StreamStep extends StatelessWidget {
  const StreamStep({super.key, required this.draft, required this.onChanged});

  final WebinarDraft draft;
  final VoidCallback onChanged;

  static const _accounts =
      <({String platform, String handle, String problem, String state})>[
        (
          platform: 'YouTube',
          handle: 'Saalt',
          problem:
              'The access token has expired. It may refresh on connect — '
              'reconnect if going live fails.',
          state: 'Needs attention',
        ),
        (
          platform: 'Twitch',
          handle: 'saaltlive',
          problem: 'The access token was revoked or expired. Please reconnect.',
          state: 'Invalid',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSection(
          title: 'Destinations',
          detail:
              'Turn on each connected account this should go live on. '
              'Only accounts saved in your integrations are listed.',
          trailing: SparkLink(label: 'Refresh', onTap: null),
          children: [
            const NoticeStrip(
              message:
                  'Two destinations cannot be streamed to. Reconnect '
                  'them before going live.',
            ),
            const SizedBox(height: 12),
            for (final account in _accounts) ...[
              WizardCard(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: const Icon(
                          Icons.podcasts_rounded,
                          size: 16,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.handle,
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
                              account.platform,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.inkFaint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: draft.destinations[account.platform] ?? false,
                        onChanged: (value) {
                          draft.destinations[account.platform] = value;
                          onChanged();
                        },
                        thumbColor: const WidgetStatePropertyAll(Colors.white),
                        trackColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? AppColors.rose
                              : AppColors.hairline,
                        ),
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.apricotTint,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          account.state,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.apricot,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const _Reconnect(),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    account.problem,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.4,
                      color: AppColors.apricot,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            _LinkRow(label: 'Manage integrations', onTap: null),
          ],
        ),
      ],
    );
  }
}

class _Reconnect extends StatelessWidget {
  const _Reconnect();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: AppColors.hairline),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          'Reconnect',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.inkFaint,
          ),
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: onTap == null ? AppColors.inkFaint : AppColors.rose,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_rounded,
                size: 13,
                color: onTap == null ? AppColors.inkFaint : AppColors.rose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Step 8. Bulk import, individual invites and a join link.
class InviteStep extends StatefulWidget {
  const InviteStep({super.key});

  @override
  State<InviteStep> createState() => _InviteStepState();
}

class _InviteStepState extends State<InviteStep> {
  final _emails = TextEditingController();

  @override
  void dispose() {
    _emails.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardSection(
          title: 'Bulk import',
          detail: 'Upload a CSV with attendee information.',
          children: [
            WizardCard(
              children: [
                UploadBox(
                  label: 'Drop a CSV here, or browse',
                  detail: 'Up to 10MB · format: email, name',
                  icon: Icons.cloud_upload_rounded,
                  onTap: null,
                ),
                const SizedBox(height: 10),
                _LinkRow(label: 'Download CSV template', onTap: null),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Email invitations',
          detail: 'Send personalised invites to specific people.',
          children: [
            WizardCard(
              children: [
                const FieldLabel('Email addresses'),
                WizardInput(
                  controller: _emails,
                  hint: 'name@company.com, hello@yourdomain.com',
                  maxLines: 3,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Separate addresses with a comma or a new line.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
                ),
                const SizedBox(height: 12),
                _SendButton(onTap: null),
              ],
            ),
          ],
        ),
        const SizedBox(height: 22),
        WizardSection(
          title: 'Share the join link',
          detail: 'Anyone with the link can register.',
          children: [
            WizardCard(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'saalt.com/tmi/your-session',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SparkLink(label: 'Copy', onTap: null),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        const NoticeStrip(
          tone: NoticeTone.good,
          message:
              'Finish adds this session to the TMI Parties list. Invites '
              'and streaming come from the console.',
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({this.onTap});

  final VoidCallback? onTap;

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
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 15, color: AppColors.ink),
                SizedBox(width: 7),
                Text(
                  'Send email invites',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
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
