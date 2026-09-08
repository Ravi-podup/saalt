import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Section heading with the supporting line the console puts under it.
class WizardSection extends StatelessWidget {
  const WizardSection({
    super.key,
    required this.title,
    required this.detail,
    required this.children,
    this.trailing,
  });

  final String title;
  final String detail;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 10), trailing!],
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

/// White panel every group of fields sits in.
class WizardCard extends StatelessWidget {
  const WizardCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(14),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.text, {
    super.key,
    this.isRequired = false,
    this.action,
  });

  final String text;
  final bool isRequired;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          // Expanded, not a bare Text with a Spacer: a long label beside an
          // action link overflowed the row. Kept as a plain Text rather than
          // Text.rich, because find.text does not match a TextSpan.
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.rose,
              ),
            ),
          const SizedBox(width: 8),
          ?action,
        ],
      ),
    );
  }
}

/// The console's "Suggest Titles" style link: a spark and a word.
class SparkLink extends StatelessWidget {
  const SparkLink({super.key, required this.label, this.onTap});

  final String label;

  /// Null renders it flat and unresponsive: the console wires these to AI
  /// drafting and clipboard work that this build does not do.
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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 12,
                color: onTap == null ? AppColors.inkFaint : AppColors.rose,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: onTap == null ? AppColors.inkFaint : AppColors.rose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WizardInput extends StatelessWidget {
  const WizardInput({
    super.key,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.prefix,
  });

  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkFaint),
        prefixIcon: prefix,
        prefixIconConstraints: const BoxConstraints(minWidth: 34),
        counterText: '',
        isDense: true,
        filled: true,
        fillColor: AppColors.canvas,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
        ),
      ),
    );
  }
}

/// The console's big two-up choice cards: icon, label, sub-label.
class ChoiceCards extends StatelessWidget {
  const ChoiceCards({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<({String label, String detail, IconData icon})> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _ChoiceCard(
              option: options[i],
              isActive: options[i].label == selected,
              onTap: () => onChanged(options[i].label),
            ),
          ),
        ],
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.option,
    required this.isActive,
    required this.onTap,
  });

  final ({String label, String detail, IconData icon}) option;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.roseTint : AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? AppColors.rose : AppColors.hairline,
                width: isActive ? 1.6 : 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.rose : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppColors.rose : AppColors.hairline,
                    ),
                  ),
                  child: Icon(
                    option.icon,
                    size: 17,
                    color: isActive ? Colors.white : AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  option.label,
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
                  option.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
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

/// Small selectable pills, wrapping.
class PillGroup extends StatelessWidget {
  const PillGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _Pill(
            label: option,
            isActive: option == selected,
            onTap: () => onChanged(option),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
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

/// Label, detail and a switch, as the console lays its settings out.
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
    this.dotColor,
  });

  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Status dot the email rows carry.
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (dotColor != null) ...[
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 9),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

/// Dashed drop zone the console uses for logos, slides and CSVs.
class UploadBox extends StatelessWidget {
  const UploadBox({
    super.key,
    required this.label,
    required this.detail,
    required this.icon,
    this.onTap,
    this.height = 128,
  });

  final String label;
  final String detail;
  final IconData icon;

  /// Null leaves the zone as a placeholder, which is what it is until there
  /// is somewhere to upload to.
  final VoidCallback? onTap;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.hairline, width: 1.4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: onTap == null
                      ? AppColors.hairline
                      : AppColors.roseTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: onTap == null ? AppColors.inkFaint : AppColors.rose,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: onTap == null ? AppColors.inkMuted : AppColors.rose,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Coloured notice, for the console's "cannot create in a past date" strip and
/// its stream warnings.
class NoticeStrip extends StatelessWidget {
  const NoticeStrip({
    super.key,
    required this.message,
    this.tone = NoticeTone.warning,
  });

  final String message;
  final NoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, icon) = switch (tone) {
      NoticeTone.warning => (
        AppColors.apricot,
        AppColors.apricotTint,
        Icons.error_outline_rounded,
      ),
      NoticeTone.good => (
        AppColors.sage,
        AppColors.sageTint,
        Icons.check_circle_outline_rounded,
      ),
      NoticeTone.info => (
        AppColors.periwinkle,
        AppColors.periwinkleTint,
        Icons.info_outline_rounded,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum NoticeTone { warning, good, info }

/// Slider row with the console's value read-out.
class SliderRow extends StatelessWidget {
  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String display;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            Text(
              display,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.rose,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            activeTrackColor: AppColors.rose,
            inactiveTrackColor: AppColors.hairline,
            thumbColor: AppColors.rose,
            overlayColor: AppColors.rose.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Divider between rows inside a card.
class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: AppColors.hairline, height: 1),
    );
  }
}
