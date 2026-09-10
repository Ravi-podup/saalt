import 'package:flutter/material.dart';
import 'package:saalt/helper/fit_quiz_helper.dart';
import 'package:saalt/models/fit_quiz.dart';
import 'package:saalt/res/app_colors.dart';

/// The question, and the line under it that says how to answer.
class QuizHeading extends StatelessWidget {
  const QuizHeading({super.key, required this.title, this.sub});

  final String title;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            height: 1.25,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: AppColors.ink,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 6),
          Text(
            sub!,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// Why the question is being asked. Every screen carries one — it is what
/// keeps the quiz from feeling nosy.
class WhyWeAsk extends StatelessWidget {
  const WhyWeAsk({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 14, 13),
      decoration: BoxDecoration(
        color: AppColors.roseTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 22,
            width: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.rose,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.question_mark_rounded,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WHY WE ASK',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.rose,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.ink,
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

/// The "Picked" flag on a chosen answer.
class PickedBadge extends StatelessWidget {
  const PickedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.wizardSelectedBorderColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 11, color: Colors.white),
          SizedBox(width: 3),
          Text(
            'Picked',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// One answer as a row: its mark, the label, and the Picked flag once chosen.
class OptionRow extends StatelessWidget {
  const OptionRow({
    super.key,
    required this.option,
    required this.isPicked,
    required this.onTap,
  });

  final QuizOption option;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPicked
          ? AppColors.wizardSelectedBackgroundColor
          : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPicked
                  ? AppColors.wizardSelectedBorderColor
                  : AppColors.hairline,
              width: isPicked ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              _Mark(option: option, isPicked: isPicked),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    if (option.sub != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        option.sub!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          height: 1.3,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isPicked) ...[const SizedBox(width: 8), const PickedBadge()],
            ],
          ),
        ),
      ),
    );
  }
}

/// The mark beside an answer, sitting in a disc: pale while the answer is
/// open, filled with the accent and flipped to a white glyph once it is
/// picked. A supplied badge already carries its own disc, so it is drawn as
/// it came instead.
class _Mark extends StatelessWidget {
  const _Mark({required this.option, required this.isPicked});

  static const _size = 38.0;

  final QuizOption option;
  final bool isPicked;

  @override
  Widget build(BuildContext context) {
    final asset = option.iconAsset;

    if (asset != null && option.iconIsBadge) {
      return SizedBox(
        width: 42,
        child: Image.asset(
          asset,
          height: _size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              _Fallback(option: option, tone: AppColors.inkFaint),
        ),
      );
    }

    final glyph = isPicked ? Colors.white : AppColors.inkFaint;

    return Container(
      height: _size,
      width: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPicked
            ? AppColors.wizardSelectedBorderColor
            : AppColors.wizardUnselectedBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: asset == null
          ? _Fallback(option: option, tone: glyph)
          : SizedBox(
              height: 14,
              width: 14,
              child: Image.asset(
                asset,
                color: glyph,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    _Fallback(option: option, tone: glyph),
              ),
            ),
    );
  }
}

/// What stands in when there is no supplied mark: the drops for a flow
/// answer, or the answer's Material icon.
class _Fallback extends StatelessWidget {
  const _Fallback({required this.option, required this.tone});

  final QuizOption option;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    if (option.drops > 0) {
      return Wrap(
        spacing: 1,
        runSpacing: 1,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < option.drops; i++)
            Icon(Icons.water_drop_rounded, size: 11, color: tone),
        ],
      );
    }

    return Icon(option.icon ?? Icons.circle_outlined, size: 17, color: tone);
  }
}

/// A cut, shown as the photograph it is easiest to recognise from.
class PhotoOption extends StatelessWidget {
  const PhotoOption({
    super.key,
    required this.option,
    required this.isPicked,
    required this.onTap,
  });

  final QuizOption option;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPicked
                ? AppColors.wizardSelectedBorderColor
                : AppColors.hairline,
            width: isPicked ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      option.imageAsset ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: AppColors.roseTint),
                    ),
                    if (isPicked)
                      const Positioned(top: 8, right: 8, child: PickedBadge()),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
              child: Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isPicked
                      ? AppColors.wizardSelectedBorderColor
                      : AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A palette, drawn as the colours themselves rather than described.
class SwatchOption extends StatelessWidget {
  const SwatchOption({
    super.key,
    required this.option,
    required this.isPicked,
    required this.onTap,
  });

  final QuizOption option;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: isPicked
              ? AppColors.wizardSelectedBackgroundColor
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPicked
                ? AppColors.wizardSelectedBorderColor
                : AppColors.hairline,
            width: isPicked ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (option.colours.isEmpty)
              Icon(
                option.icon ?? Icons.auto_awesome_rounded,
                size: 26,
                color: isPicked
                    ? AppColors.wizardSelectedBorderColor
                    : AppColors.inkFaint,
              )
            else
              Row(
                children: [
                  for (final colour in option.colours)
                    Container(
                      height: 26,
                      width: 26,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: colour,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.hairline),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              option.label,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One product in the stance grid: reaching for it, ruling it out, or still
/// wondering.
class MatrixCard extends StatelessWidget {
  const MatrixCard({
    super.key,
    required this.product,
    required this.stance,
    required this.onStance,
  });

  final MatrixProduct product;

  /// Index into [FitQuizHelper.matrixStances], or null while unanswered.
  final int? stance;

  final ValueChanged<int> onStance;

  @override
  Widget build(BuildContext context) {
    final answered = stance != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: answered
              ? AppColors.wizardSelectedBorderColor
              : AppColors.hairline,
          width: answered ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.wizardIconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: product.iconAsset == null
                    ? Icon(
                        product.icon,
                        size: 17,
                        color: AppColors.wizardSelectedBorderColor,
                      )
                    : Image.asset(
                        product.iconAsset!,
                        height: 12,
                        color: AppColors.wizardSelectedBorderColor,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          product.icon,
                          size: 17,
                          color: AppColors.wizardSelectedBorderColor,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  product.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < FitQuizHelper.matrixStances.length; i++)
                _StanceChip(
                  label: FitQuizHelper.matrixStances[i],
                  isPicked: stance == i,
                  onTap: () => onStance(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StanceChip extends StatelessWidget {
  const _StanceChip({
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
      color: isPicked ? AppColors.wizardSelectedBorderColor : AppColors.canvas,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isPicked
                  ? AppColors.wizardSelectedBorderColor
                  : AppColors.hairline,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPicked ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// A short answer as a pill: age ranges, sizes, bra bands.
class QuizChip extends StatelessWidget {
  const QuizChip({
    super.key,
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
      color: isPicked ? AppColors.wizardSelectedBorderColor : AppColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isPicked
                  ? AppColors.wizardSelectedBorderColor
                  : AppColors.hairline,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isPicked ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled text field, as the quiz's forms use it.
class QuizField extends StatelessWidget {
  const QuizField({
    super.key,
    required this.hint,
    required this.controller,
    this.icon,
    this.keyboardType,
  });

  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 18, color: AppColors.inkFaint),
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.inkFaint),
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
          borderSide: const BorderSide(
            color: AppColors.wizardSelectedBorderColor,
          ),
        ),
      ),
    );
  }
}

/// A standing note under a set of answers, such as the PFAS line.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.text,
    this.icon,
    this.iconAsset,
    this.tone,
  });

  final String text;
  final IconData? icon;

  /// A supplied mark, used in preference to [icon] and tinted to the
  /// banner's own accent so the two cannot drift apart.
  final String? iconAsset;

  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final accent = tone ?? AppColors.sage;
    final fallback = Icon(
      icon ?? Icons.verified_outlined,
      size: 15,
      color: accent,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 14, 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconAsset == null)
            fallback
          else
            Image.asset(
              iconAsset!,
              height: 15,
              width: 15,
              color: accent,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => fallback,
            ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A checkbox row, as the nudge and terms rows use it.
class QuizCheckRow extends StatelessWidget {
  const QuizCheckRow({
    super.key,
    required this.title,
    this.sub,
    required this.isOn,
    required this.onTap,
  });

  final String title;
  final String? sub;
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
                color: isOn
                    ? AppColors.wizardSelectedBorderColor
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isOn
                      ? AppColors.wizardSelectedBorderColor
                      : AppColors.inkFaint,
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
            const SizedBox(width: 10),
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
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sub!,
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

/// A closed dropdown field: what is chosen, or the placeholder, plus the
/// chevron that says it opens.
class QuizDropdown extends StatelessWidget {
  const QuizDropdown({
    super.key,
    required this.placeholder,
    required this.value,
    required this.isOpen,
    required this.onTap,
  });

  final String placeholder;
  final String? value;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chosen = value != null;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(13, 13, 9, 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOpen || chosen
                  ? AppColors.wizardSelectedBorderColor
                  : AppColors.hairline,
              width: isOpen || chosen ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: chosen ? AppColors.ink : AppColors.inkMuted,
                  ),
                ),
              ),
              Icon(
                isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 19,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The panel a dropdown opens: short values laid out as pills.
class QuizDropdownPanel extends StatelessWidget {
  const QuizDropdownPanel({
    super.key,
    required this.options,
    required this.value,
    required this.onSelect,
  });

  final List<String> options;
  final String? value;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          for (final option in options)
            QuizChip(
              label: option,
              isPicked: option == value,
              onTap: () => onSelect(option),
            ),
        ],
      ),
    );
  }
}

/// The pant-size dropdown's panel, which is the fit guide itself: pick the
/// row your measurements land on.
class PantSizePanel extends StatelessWidget {
  const PantSizePanel({super.key, required this.value, required this.onSelect});

  final String? value;
  final ValueChanged<FitGuideRow> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FitQuizHelper.fitGuideKicker.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.rose,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            FitQuizHelper.fitGuideHeading,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            FitQuizHelper.fitGuideNote,
            style: TextStyle(fontSize: 10.5, color: AppColors.inkFaint),
          ),
          const SizedBox(height: 10),
          for (final row in FitQuizHelper.fitGuide)
            _PantOption(
              row: row,
              isPicked: row.label == value,
              onTap: () => onSelect(row),
            ),
        ],
      ),
    );
  }
}

class _PantOption extends StatelessWidget {
  const _PantOption({
    required this.row,
    required this.isPicked,
    required this.onTap,
  });

  final FitGuideRow row;
  final bool isPicked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPicked
          ? AppColors.wizardSelectedBackgroundColor
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  row.size,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isPicked
                        ? AppColors.wizardSelectedBorderColor
                        : AppColors.ink,
                  ),
                ),
              ),
              Expanded(
                // Four metrics, not five: the row has to stay one line at
                // phone width, so Youth is left to the size-guide sheet.
                child: Row(
                  children: [
                    Expanded(
                      child: _Metric(label: 'Waist', value: row.waist),
                    ),
                    Expanded(
                      child: _Metric(label: 'Hips', value: row.hips),
                    ),
                    Expanded(
                      child: _Metric(label: 'US Pant', value: row.usPant),
                    ),
                    Expanded(
                      child: _Metric(label: 'UK Trouser', value: row.uk),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One measurement on a fit-guide row: what it is, then what it reads.
class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 8.5, color: AppColors.inkFaint),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}

/// "See our size guide", as the fit screen links it.
class SizeGuideLink extends StatelessWidget {
  const SizeGuideLink({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.straighten_rounded,
              size: 13,
              color: AppColors.rose,
            ),
            const SizedBox(width: 5),
            Text(
              FitQuizHelper.fitGuideLink,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.rose,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.rose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The fit guide as a sheet, for the "See our size guide" links.
class FitGuideSheet extends StatelessWidget {
  const FitGuideSheet({super.key});

  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FitGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              FitQuizHelper.fitGuideHeading,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              FitQuizHelper.fitGuideNote,
              style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted),
            ),
            const SizedBox(height: 14),
            const _GuideHead(),
            for (final row in FitQuizHelper.fitGuide) _GuideRow(row: row),
          ],
        ),
      ),
    );
  }
}

class _GuideHead extends StatelessWidget {
  const _GuideHead();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.7,
      color: AppColors.inkFaint,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('SIZE', style: style)),
          Expanded(flex: 3, child: Text('WAIST', style: style)),
          Expanded(flex: 3, child: Text('HIPS', style: style)),
          Expanded(flex: 2, child: Text('US', style: style)),
          Expanded(flex: 2, child: Text('UK', style: style)),
          Expanded(flex: 2, child: Text('YOUTH', style: style)),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.row});

  final FitGuideRow row;

  @override
  Widget build(BuildContext context) {
    const size = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    );
    const body = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: AppColors.inkMuted,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(row.size, style: size)),
          Expanded(flex: 3, child: Text(row.waist, style: body)),
          Expanded(flex: 3, child: Text(row.hips, style: body)),
          Expanded(flex: 2, child: Text(row.usPant, style: body)),
          Expanded(flex: 2, child: Text(row.uk, style: body)),
          Expanded(flex: 2, child: Text(row.youth ?? '—', style: body)),
        ],
      ),
    );
  }
}
