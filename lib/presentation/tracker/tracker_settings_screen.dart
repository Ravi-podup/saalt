import 'package:flutter/material.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/helper/tracker_settings.dart';
import 'package:saalt/models/tracker_prefs.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';

/// Tracker settings. The two lengths are the ones that matter: they drive the
/// predictions, so changing them here moves the calendar shading, the phase
/// labels and the countdown together.
class TrackerSettingsScreen extends StatelessWidget {
  const TrackerSettingsScreen({super.key});

  void _toast(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Tracker settings',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ValueListenableBuilder<TrackerPrefs>(
                valueListenable: TrackerSettings.prefs,
                builder: (context, prefs, _) {
                  return ListView(
                    key: const Key('settings-body'),
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                    children: [
                      _Group(
                        title: 'Your cycle',
                        footer:
                            'Left alone, both come from your logged cycles. '
                            'Set one by hand and every prediction follows it.',
                        children: [
                          _StepperRow(
                            label: 'Period length',
                            value: TrackerHelper.averagePeriod,
                            isFromLogs: prefs.periodLength == null,
                            min: TrackerPrefs.minPeriod,
                            max: TrackerPrefs.maxPeriod,
                            onStep: (by) => TrackerSettings.stepPeriod(
                              by,
                              from: TrackerHelper.averagePeriod,
                            ),
                          ),
                          const _RowDivider(),
                          _StepperRow(
                            label: 'Cycle length',
                            value: TrackerHelper.averageCycle,
                            isFromLogs: prefs.cycleLength == null,
                            min: TrackerPrefs.minCycle,
                            max: TrackerPrefs.maxCycle,
                            onStep: (by) => TrackerSettings.stepCycle(
                              by,
                              from: TrackerHelper.averageCycle,
                            ),
                          ),
                          if (prefs.overridesLengths) ...[
                            const _RowDivider(),
                            _ActionRow(
                              label: 'Use my logged averages',
                              detail:
                                  '${TrackerHelper.loggedAveragePeriod} day '
                                  'period, '
                                  '${TrackerHelper.loggedAverageCycle} day '
                                  'cycle',
                              icon: Icons.restart_alt_rounded,
                              onTap: () {
                                TrackerSettings.update(
                                  prefs.withLoggedLengths(),
                                );
                                _toast(context, 'Back to your logged averages');
                              },
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Group(
                        title: 'Calendar',
                        children: [
                          _ChoiceRow(
                            label: 'First day of week',
                            options: const ['Monday', 'Sunday'],
                            selected: prefs.weekStartsOnSunday
                                ? 'Sunday'
                                : 'Monday',
                            onChanged: (value) => TrackerSettings.update(
                              prefs.copyWith(
                                weekStartsOnSunday: value == 'Sunday',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Group(
                        title: 'Reminders',
                        footer:
                            'Saved here, but nothing is scheduled on your '
                            'phone yet — that needs notification permissions.',
                        children: [
                          _SwitchRow(
                            label: 'Period due',
                            detail: 'Two days before the next expected start',
                            value: prefs.periodReminder,
                            onChanged: (value) => TrackerSettings.update(
                              prefs.copyWith(periodReminder: value),
                            ),
                          ),
                          const _RowDivider(),
                          _SwitchRow(
                            label: 'Fertile window',
                            detail: 'On the first day of the window',
                            value: prefs.ovulationReminder,
                            onChanged: (value) => TrackerSettings.update(
                              prefs.copyWith(ovulationReminder: value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Group(
                        title: 'Data',
                        footer:
                            'Your logs live on this device for this session '
                            'only. Nothing is uploaded, and nothing survives '
                            'a restart.',
                        children: [
                          _ActionRow(
                            label: 'Reset all tracker settings',
                            detail: 'Lengths, week start and reminders',
                            icon: Icons.delete_outline_rounded,
                            isDestructive: true,
                            onTap: () {
                              TrackerSettings.update(const TrackerPrefs());
                              _toast(context, 'Tracker settings reset');
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children, this.footer});

  final String title;
  final List<Widget> children;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: AppColors.inkFaint,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(children: children),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 9, 4, 0),
            child: Text(
              footer!,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.45,
                color: AppColors.inkFaint,
              ),
            ),
          ),
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(color: AppColors.hairline, height: 1),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.isFromLogs,
    required this.min,
    required this.max,
    required this.onStep,
  });

  final String label;
  final int value;

  /// Untouched values are worth marking: it tells someone the number moves
  /// with their logs rather than sitting where they left it.
  final bool isFromLogs;

  final int min;
  final int max;
  final ValueChanged<int> onStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isFromLogs ? 'From your logs' : 'Set by you',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // Wide enough for two digits and the unit at this weight, so the
            // steppers stay put as the number changes.
            width: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    '$value',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  'd',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkFaint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StepButton(
            icon: Icons.remove_rounded,
            tooltip: 'Decrease $label',
            onTap: value > min ? () => onStep(-1) : null,
          ),
          const SizedBox(width: 8),
          _StepButton(
            icon: Icons.add_rounded,
            tooltip: 'Increase $label',
            onTap: value < max ? () => onStep(1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isEnabled ? AppColors.rose : AppColors.hairline,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 36,
            width: 36,
            child: Icon(
              icon,
              size: 19,
              color: isEnabled ? Colors.white : AppColors.inkFaint,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  maxLines: 2,
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
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                for (final option in options)
                  _ChoicePill(
                    label: option,
                    isActive: option == selected,
                    onTap: () => onChanged(option),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.ink : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : AppColors.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.detail,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final tone = isDestructive ? AppColors.rose : AppColors.ink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: [
              Icon(icon, size: 17, color: tone),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: tone,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.35,
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: AppColors.inkFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
