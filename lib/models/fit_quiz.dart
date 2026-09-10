import 'package:flutter/material.dart';

/// Whether a question takes one answer or several.
enum QuizPick { single, multi }

/// How a question's answers are laid out.
enum QuizLayout {
  /// Stacked rows with an icon and a label. The default.
  rows,

  /// Photograph tiles, two to a row.
  photos,

  /// Colour-palette tiles.
  swatches,
}

/// One answer to a question.
class QuizOption {
  const QuizOption({
    required this.value,
    required this.label,
    this.sub,
    this.icon,
    this.iconAsset,
    this.iconIsBadge = false,
    this.drops = 0,
    this.imageAsset,
    this.colours = const [],
    this.isCatchAll = false,
  });

  final String value;
  final String label;

  /// Supporting line: the collection a vibe maps to, or a note on the answer.
  final String? sub;

  final IconData? icon;

  /// A supplied mark, used in preference to [icon]. Drawn as a silhouette
  /// tinted to the row's tone, so the source file's own colour does not
  /// matter.
  final String? iconAsset;

  /// True when [iconAsset] is a finished badge — its own disc and colour — so
  /// it is drawn larger and left untinted. A flat silhouette gets tinted to
  /// the row's tone instead.
  final bool iconIsBadge;

  /// Flow weight, drawn as that many drops when there is no [iconAsset].
  final int drops;

  final String? imageAsset;

  /// Palette for a swatch tile.
  final List<Color> colours;

  /// "Just pick for me" — choosing it clears the other answers, and picking
  /// anything else clears it.
  final bool isCatchAll;
}

/// One question screen in the quiz.
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.title,
    this.sub,
    required this.whyWeAsk,
    required this.pick,
    required this.options,
    this.layout = QuizLayout.rows,
    this.footnote,
    this.footnoteIconAsset,
  });

  final String id;
  final String title;
  final String? sub;

  /// The "Why we ask" note. Every question has one — it is what makes the
  /// quiz feel answerable rather than nosy.
  final String whyWeAsk;

  final QuizPick pick;
  final List<QuizOption> options;
  final QuizLayout layout;

  /// Standing note under the answers, such as the PFAS line.
  final String? footnote;

  /// The mark on that note.
  final String? footnoteIconAsset;
}

/// A product in the "reaching for, ruling out, wondering about" grid.
class MatrixProduct {
  const MatrixProduct({
    required this.value,
    required this.label,
    required this.icon,
    this.iconAsset,
  });

  final String value;
  final String label;
  final IconData icon;

  /// A supplied mark, used in preference to [icon].
  final String? iconAsset;
}

/// One piece of the recommended Stack.
class StackPick {
  const StackPick({
    required this.name,
    required this.reason,
    required this.size,
    required this.colour,
    required this.absorbency,
    this.imageAsset,
  });

  final String name;

  /// Why this one made the cut — the line that does the persuading.
  final String reason;

  final String size;
  final String colour;
  final String absorbency;
  final String? imageAsset;
}

/// One of the three "your first cycle" steps on the result screen.
class QuizStepCard {
  const QuizStepCard({
    required this.number,
    required this.name,
    required this.detail,
    required this.icon,
  });

  final String number;
  final String name;
  final String detail;
  final IconData icon;
}

/// One row of the Saalt fit guide. Doubles as an option in the pant-size
/// dropdown, where picking a row picks that size.
class FitGuideRow {
  const FitGuideRow({
    required this.size,
    required this.usPant,
    required this.waist,
    required this.hips,
    required this.uk,
    this.youth,
  });

  final String size;

  /// US pant size this maps to, which is the way the dropdown is labelled.
  final String usPant;

  final String waist;
  final String hips;
  final String uk;

  /// Only the smaller sizes carry a youth equivalent.
  final String? youth;

  /// How the field reads once this row is chosen.
  String get label => '$size — US $usPant';
}
