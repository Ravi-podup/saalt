import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/webinar_draft.dart';
import 'package:saalt/presentation/parties/wizard/wizard_widgets.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// The brief, on its own screen. Step one is already the longest in the flow,
/// and describing a session is a different job from filling in its fields —
/// so it gets its own surface rather than an inline panel that competes with
/// the very fields it fills.
class BriefScreen extends StatefulWidget {
  const BriefScreen({super.key, required this.draft});

  static const kDraft = 'draft';

  /// Resolves true when the brief was carried into the draft.
  static Future<bool?> open(
    BuildContext context, {
    required WebinarDraft draft,
  }) {
    return context.push<bool>(
      AppRoutePaths.briefScreen,
      extra: {kDraft: draft},
    );
  }

  final WebinarDraft draft;

  @override
  State<BriefScreen> createState() => _BriefScreenState();
}

class _BriefScreenState extends State<BriefScreen> {
  late final _about = TextEditingController(text: widget.draft.about);
  late final _goal = TextEditingController(text: widget.draft.goal);

  late String? _audience = widget.draft.briefAudience;
  late String? _level = widget.draft.level;
  late String? _tone = widget.draft.tone;
  late DateTime? _date = widget.draft.date;
  late TimeOfDay? _time = widget.draft.time;
  late bool _isPaid = widget.draft.isPaid;

  @override
  void dispose() {
    _about.dispose();
    _goal.dispose();
    super.dispose();
  }

  Future<void> _pickWhen() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (!mounted) return;
    setState(() {
      _date = date;
      _time = time ?? _time;
    });
  }

  bool get _hasAnything =>
      _about.text.trim().isNotEmpty ||
      _goal.text.trim().isNotEmpty ||
      _audience != null ||
      _level != null ||
      _tone != null ||
      _date != null;

  void _use() {
    final draft = widget.draft
      ..about = _about.text
      ..goal = _goal.text
      ..briefAudience = _audience
      ..level = _level
      ..tone = _tone
      ..isPaid = _isPaid;

    if (_date != null) draft.date = _date;
    if (_time != null) draft.time = _time;

    draft.applyBrief();
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final when = _date == null
        ? null
        : DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _time?.hour ?? 0,
            _time?.minute ?? 0,
          );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Start with a brief',
              subtitle: 'Describe the session and we fill in what we can',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                key: const Key('brief-body'),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  WizardCard(
                    children: [
                      const FieldLabel('What is this session about?'),
                      const Text(
                        'A sentence is enough.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.inkFaint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      WizardInput(
                        controller: _about,
                        hint:
                            'e.g. Everything a first-time cup user needs, '
                            'start to finish.',
                        maxLines: 4,
                        maxLength: 1000,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 5),
                      _Counter(count: _about.text.length, max: 1000),
                      const CardDivider(),
                      const FieldLabel('Main goal for attendees'),
                      const Text(
                        'Optional. The one thing they should leave with.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.inkFaint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      WizardInput(
                        controller: _goal,
                        hint: 'e.g. Insert and remove a cup with confidence.',
                        maxLength: 150,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 5),
                      _Counter(count: _goal.text.length, max: 150),
                    ],
                  ),
                  const SizedBox(height: 16),
                  WizardCard(
                    children: [
                      const FieldLabel('When is it?'),
                      const Text(
                        'Optional here — you can set it on the setup step.',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.inkFaint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _pickWhen,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.hairline),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    when == null
                                        ? 'Pick a date and time'
                                        : '${DateLabels.weekdayDayMonth(when)}'
                                              ' · ${DateLabels.time(when)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: when == null
                                          ? AppColors.inkFaint
                                          : AppColors.ink,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.event_rounded,
                                  size: 15,
                                  color: AppColors.inkFaint,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  WizardCard(
                    children: [
                      const FieldLabel('Who is it for?'),
                      const SizedBox(height: 4),
                      _OptionalPills(
                        options: WebinarDraft.audiences,
                        selected: _audience,
                        onChanged: (value) => setState(() => _audience = value),
                      ),
                      const CardDivider(),
                      const FieldLabel('Experience level'),
                      const SizedBox(height: 4),
                      _OptionalPills(
                        options: WebinarDraft.levels,
                        selected: _level,
                        onChanged: (value) => setState(() => _level = value),
                      ),
                      const CardDivider(),
                      const FieldLabel('Tone'),
                      const SizedBox(height: 4),
                      _OptionalPills(
                        options: WebinarDraft.tones,
                        selected: _tone,
                        onChanged: (value) => setState(() => _tone = value),
                      ),
                      const CardDivider(),
                      const FieldLabel('Will you charge for this?'),
                      const SizedBox(height: 4),
                      PillGroup(
                        options: const ['Free', 'Paid'],
                        selected: _isPaid ? 'Paid' : 'Free',
                        onChanged: (value) =>
                            setState(() => _isPaid = value == 'Paid'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const NoticeStrip(
                    tone: NoticeTone.info,
                    message:
                        'What you write here fills the description and '
                        'the first objective. Titles are not generated — '
                        'there is no model behind this build.',
                  ),
                ],
              ),
            ),
            _Footer(onUse: _hasAnything ? _use : null),
          ],
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.count, required this.max});

  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '$count/$max',
        style: const TextStyle(fontSize: 10, color: AppColors.inkFaint),
      ),
    );
  }
}

/// Pills that can be turned off again by tapping the chosen one, since every
/// group on this screen is optional.
class _OptionalPills extends StatelessWidget {
  const _OptionalPills({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PillGroup(
      options: options,
      selected: selected ?? '',
      onChanged: (value) => onChanged(value == selected ? null : value),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({this.onUse});

  final VoidCallback? onUse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: onUse == null ? AppColors.hairline : AppColors.ink,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: onUse,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: onUse == null ? AppColors.inkFaint : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Use this brief',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: onUse == null ? AppColors.inkFaint : Colors.white,
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
