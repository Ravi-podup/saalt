import 'package:flutter/material.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/wizard/wizard_steps_a.dart';
import 'package:saalt/presentation/parties/wizard/wizard_steps_b.dart';
import 'package:saalt/presentation/parties/wizard/wizard_steps_c.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';

/// The eight steps of the console's create flow.
enum WizardStep {
  setup(
    'Setup',
    'Create your webinar',
    'Add the title, schedule and details '
        'your attendees will see.',
  ),
  speakers(
    'Speakers',
    'Add your speakers',
    'Hosts, presenters and panelists '
        'who will join this webinar.',
  ),
  emails(
    'Emails',
    'Set up your emails',
    'Pick who you are emailing '
        'and which emails go out.',
  ),
  thumbnail(
    'Thumbnail',
    'Create your thumbnail',
    'Artwork sized for every '
        'place this gets shared.',
  ),
  review(
    'Review',
    'Preview and review',
    'Check each section, then '
        'continue when it reads right.',
  ),
  social(
    'Social',
    'Share on social',
    'Draft the posts that announce '
        'this session.',
  ),
  stream(
    'Stream',
    'Stream settings',
    'Pick the connected platforms '
        'this webinar is simulcast to.',
  ),
  invite(
    'Invite',
    'Invite attendees',
    'Send invitations to your '
        'colleagues, clients and network.',
  );

  const WizardStep(this.railLabel, this.title, this.detail);

  /// Short label for the step rail.
  final String railLabel;

  final String title;
  final String detail;
}

/// Eight-step create flow, laid out for a phone. The console runs this as a
/// left rail and a wide canvas; here the rail scrolls across the top and each
/// step owns the full width.
class WebinarWizardScreen extends StatefulWidget {
  const WebinarWizardScreen({super.key});

  @override
  State<WebinarWizardScreen> createState() => _WebinarWizardScreenState();
}

class _WebinarWizardScreenState extends State<WebinarWizardScreen> {
  final _draft = WebinarDraft();
  final _railController = ScrollController();
  final _bodyController = ScrollController();

  var _step = WizardStep.setup;
  final _visited = <WizardStep>{WizardStep.setup};

  /// Set when Finish is refused, so the setup step can say what is missing
  /// in place rather than through a message that disappears.
  var _showRequirements = false;

  @override
  void dispose() {
    _railController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  int get _index => WizardStep.values.indexOf(_step);

  double get _progress =>
      (_visited.length / WizardStep.values.length).clamp(0.0, 1.0);

  void _goTo(WizardStep step) {
    setState(() {
      _step = step;
      _visited.add(step);
      if (_bodyController.hasClients) _bodyController.jumpTo(0);
    });
    _revealInRail(WizardStep.values.indexOf(step));
  }

  /// Keeps the current step's chip on screen as the flow moves on.
  void _revealInRail(int index) {
    if (!_railController.hasClients) return;
    const chipWidth = 132.0;
    final target = (index * chipWidth) - 60;
    _railController.animateTo(
      target.clamp(0, _railController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_index < WizardStep.values.length - 1) {
      _goTo(WizardStep.values[_index + 1]);
      return;
    }
    _finish();
  }

  void _back() {
    if (_index == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    _goTo(WizardStep.values[_index - 1]);
  }

  /// The one part of the flow that is not design only: the draft becomes a
  /// real card on the TMI Parties list.
  void _finish() {
    if (!_draft.canFinish) {
      setState(() => _showRequirements = true);
      _goTo(WizardStep.setup);
      return;
    }

    final look = _draft.look;
    final startsAt =
        _draft.startsAt ?? DateTime.now().add(const Duration(minutes: 1));

    SessionStore.add(
      TmiParty.scheduled(
        id: 'wizard-${DateTime.now().microsecondsSinceEpoch}',
        title: _draft.title.trim(),
        blurb: _draft.description.trim().isEmpty
            ? 'A ${_draft.isLive ? 'live' : 'pre-recorded'} session.'
            : _draft.description.trim(),
        host: _draft.speakers.isEmpty
            ? 'Saalt Care Team'
            : _draft.speakers.first.name.isEmpty
            ? 'Saalt Care Team'
            : _draft.speakers.first.name,
        startsAt: startsAt,
        minutes: _draft.minutes,
        topics: [_draft.isLive ? 'Live' : 'On-demand', _draft.language],
        capacity: _draft.capacity,
        tint: look.tint,
        accent: look.accent,
        icon: look.icon,
      ),
    );

    Navigator.of(context).pop();
    _toast('${_draft.title.trim()} is on the schedule');
  }

  void _toast(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1700),
      ),
    );
  }

  Widget get _body => switch (_step) {
    WizardStep.setup => SetupStep(
      draft: _draft,
      showRequirements: _showRequirements,
      onChanged: () => setState(() {}),
    ),
    WizardStep.speakers => SpeakersStep(
      draft: _draft,
      onChanged: () => setState(() {}),
      onSkip: _next,
    ),
    WizardStep.emails => EmailsStep(
      draft: _draft,
      onChanged: () => setState(() {}),
    ),
    WizardStep.thumbnail => ThumbnailStep(
      draft: _draft,
      onChanged: () => setState(() {}),
    ),
    WizardStep.review => ReviewStep(draft: _draft, onEdit: _goTo),
    WizardStep.social => const SocialStep(),
    WizardStep.stream => StreamStep(
      draft: _draft,
      onChanged: () => setState(() {}),
    ),
    WizardStep.invite => const InviteStep(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Schedule a webinar',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            _StepRail(
              controller: _railController,
              current: _step,
              visited: _visited,
              onTap: _goTo,
            ),
            Expanded(
              child: ListView(
                key: const Key('wizard-body'),
                controller: _bodyController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Text(
                    'STEP ${_index + 1} OF ${WizardStep.values.length}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.rose,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _step.title,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _step.detail,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _body,
                ],
              ),
            ),
            _WizardFooter(
              progress: _progress,
              isLast: _index == WizardStep.values.length - 1,
              onBack: _back,
              onSkip: _index == WizardStep.values.length - 1 ? null : _next,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

/// The console's numbered rail, turned on its side for a phone.
class _StepRail extends StatelessWidget {
  const _StepRail({
    required this.controller,
    required this.current,
    required this.visited,
    required this.onTap,
  });

  final ScrollController controller;
  final WizardStep current;
  final Set<WizardStep> visited;
  final ValueChanged<WizardStep> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        key: const Key('wizard-rail'),
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (var i = 0; i < WizardStep.values.length; i++) ...[
            _RailChip(
              number: i + 1,
              label: WizardStep.values[i].railLabel,
              isCurrent: WizardStep.values[i] == current,
              isDone:
                  visited.contains(WizardStep.values[i]) &&
                  WizardStep.values[i] != current,
              onTap: () => onTap(WizardStep.values[i]),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _RailChip extends StatelessWidget {
  const _RailChip({
    required this.number,
    required this.label,
    required this.isCurrent,
    required this.isDone,
    required this.onTap,
  });

  final int number;
  final String label;
  final bool isCurrent;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = isCurrent ? AppColors.ink : AppColors.surface;
    final foreground = isCurrent ? Colors.white : AppColors.inkMuted;

    return Center(
      child: Semantics(
        button: true,
        selected: isCurrent,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isCurrent ? AppColors.ink : AppColors.hairline,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.sage
                          : isCurrent
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.canvas,
                      shape: BoxShape.circle,
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: Colors.white,
                          )
                        : Text(
                            '$number',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: foreground,
                            ),
                          ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Back, Skip and the primary action over a progress bar, as the console has.
class _WizardFooter extends StatelessWidget {
  const _WizardFooter({
    required this.progress,
    required this.isLast,
    required this.onBack,
    required this.onNext,
    this.onSkip,
  });

  final double progress;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.hairline,
                      valueColor: const AlwaysStoppedAnimation(AppColors.sage),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progress * 100).round()}% done',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _TextAction(
                label: 'Back',
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const Spacer(),
              if (onSkip != null) _TextAction(label: 'Skip', onTap: onSkip!),
              const SizedBox(width: 10),
              _PrimaryAction(
                label: isLast ? 'Finish' : 'Continue',
                onTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: AppColors.inkMuted),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
