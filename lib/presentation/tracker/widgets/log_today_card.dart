import 'package:flutter/material.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/res/app_colors.dart';

/// One day's entry: flow, symptoms, mood. Deliberately one screenful - the
/// longer this form gets, the fewer days people actually log.
class LogTodayCard extends StatelessWidget {
  const LogTodayCard({
    super.key,
    this.title = 'Log today',
    required this.flow,
    required this.symptoms,
    required this.mood,
    required this.onFlow,
    required this.onSymptom,
    required this.onMood,
    this.onSave,
    this.isSaved = false,
    this.saveLabel = 'Save entry',
    this.canSave,
  });

  /// Heading, so the same form can carry a date other than today.
  final String title;

  final String? flow;
  final Set<String> symptoms;
  final String? mood;
  final ValueChanged<String> onFlow;
  final ValueChanged<String> onSymptom;
  final ValueChanged<String> onMood;
  final VoidCallback? onSave;
  final bool isSaved;

  final String saveLabel;

  /// Overrides the default rule. A day that already has a stored entry can be
  /// saved empty, which is how an entry gets cleared.
  final bool? canSave;

  bool get _hasEntry =>
      canSave ?? (flow != null || symptoms.isNotEmpty || mood != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (isSaved)
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: AppColors.sage,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Saved',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sage,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          _Group(
            label: 'Flow',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final level in TrackerHelper.flowLevels)
                  _Chip(
                    label: level,
                    isActive: level == flow,
                    onTap: () => onFlow(level),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Group(
            label: 'Symptoms',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final symptom in TrackerHelper.symptoms)
                  _Chip(
                    label: symptom,
                    isActive: symptoms.contains(symptom),
                    onTap: () => onSymptom(symptom),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Group(
            label: 'Mood',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in TrackerHelper.moods)
                  _Chip(
                    label: option,
                    isActive: option == mood,
                    onTap: () => onMood(option),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: _hasEntry ? AppColors.ink : AppColors.hairline,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: _hasEntry ? onSave : null,
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    saveLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _hasEntry ? Colors.white : AppColors.inkFaint,
                    ),
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

class _Group extends StatelessWidget {
  const _Group({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
        color: isActive ? AppColors.ink : AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppColors.ink : AppColors.hairline,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
