import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/fit_quiz_helper.dart';
import 'package:saalt/models/fit_quiz.dart';
import 'package:saalt/presentation/quiz/widgets/quiz_result.dart';
import 'package:saalt/presentation/quiz/widgets/quiz_widgets.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// The pages of the quiz, in order.
enum _Page {
  intro,
  shoppingFor,
  matrix,
  flow,
  cuts,
  occasion,
  colourVibe,
  fit,
  cupsDiscs,
  contact,
  result,
}

/// "Find your fit": a guided quiz that lands on a recommended Saalt Stack.
///
/// The answers are held for the length of the visit so every screen reads
/// back what was picked. The Stack at the end is a fixed example rather than
/// something computed from the answers.
class FitQuizScreen extends StatefulWidget {
  const FitQuizScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.fitQuizScreen);
  }

  @override
  State<FitQuizScreen> createState() => _FitQuizScreenState();
}

class _FitQuizScreenState extends State<FitQuizScreen> {
  final _scroll = ScrollController();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  _Page _page = _Page.intro;

  String? _ageRange;
  final _shoppingFor = <String>{};
  final _matrix = <String, int>{};
  final _cuts = <String>{};
  final _occasion = <String>{};

  /// Single-answer questions, keyed by question id.
  final _single = <String, String>{};
  String? _size;
  String? _pantSize;
  String? _braBand;
  String? _braCup;
  String? _braSize;

  /// Id of the dropdown standing open, if any.
  String? _openDropdown;
  final _cupExperience = <String>{};
  String? _sexAnswer;
  bool _nudge = true;
  bool _terms = false;

  @override
  void dispose() {
    _scroll.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Which step this is, 1-based, counting the intro as step one. Null on the
  /// result, which is the outcome rather than a step towards it.
  int? get _stepNumber {
    final index = _Page.values.indexOf(_page);
    if (index >= _stepCount) return null;
    return index + 1;
  }

  /// The intro plus the nine questions.
  static const _stepCount = 10;

  void _goTo(_Page page) {
    setState(() => _page = page);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _next() {
    final index = _Page.values.indexOf(_page);
    if (index < _Page.values.length - 1) _goTo(_Page.values[index + 1]);
  }

  void _back() {
    final index = _Page.values.indexOf(_page);
    if (index == 0) {
      context.pop();
      return;
    }
    _goTo(_Page.values[index - 1]);
  }

  /// Multi-select with a catch-all: "just pick for me" clears the rest, and
  /// picking anything else clears it.
  void _toggleMulti(Set<String> into, QuizQuestion question, String value) {
    final option = question.options.firstWhere((o) => o.value == value);
    setState(() {
      if (option.isCatchAll) {
        final wasOn = into.contains(value);
        into.clear();
        if (!wasOn) into.add(value);
        return;
      }
      for (final catchAll in question.options.where((o) => o.isCatchAll)) {
        into.remove(catchAll.value);
      }
      into.contains(value) ? into.remove(value) : into.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _QuizHeader(
              stepNumber: _stepNumber,
              stepCount: _stepCount,
              onBack: _back,
            ),
            Expanded(
              child: ListView(
                controller: _scroll,
                key: const Key('quiz-body'),
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                children: _body(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _QuizFooter(
        page: _page,
        onBack: _back,
        onNext: _next,
        onRestart: () => _goTo(_Page.intro),
      ),
    );
  }

  List<Widget> _body() => switch (_page) {
    _Page.intro => _intro(),
    _Page.shoppingFor => _question(
      FitQuizHelper.shoppingFor,
      picked: _shoppingFor,
    ),
    _Page.matrix => _matrixPage(),
    _Page.flow => _question(FitQuizHelper.flow),
    _Page.cuts => _question(FitQuizHelper.cuts, picked: _cuts),
    _Page.occasion => _question(FitQuizHelper.occasion, picked: _occasion),
    _Page.colourVibe => _question(FitQuizHelper.colourVibe),
    _Page.fit => _fit(),
    _Page.cupsDiscs => _cupsDiscs(),
    _Page.contact => _contact(),
    _Page.result => _result(),
  };

  // ---------------------------------------------------------------- intro

  List<Widget> _intro() => [
    const SizedBox(height: 8),
    const Text(
      FitQuizHelper.introTitle,
      style: TextStyle(
        fontSize: 27,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: AppColors.ink,
      ),
    ),
    const SizedBox(height: 12),
    const Text(
      FitQuizHelper.introBody,
      style: TextStyle(fontSize: 13, height: 1.55, color: AppColors.inkMuted),
    ),
    const SizedBox(height: 10),
    const Text(
      FitQuizHelper.introBodyTwo,
      style: TextStyle(fontSize: 13, height: 1.55, color: AppColors.inkMuted),
    ),
    const SizedBox(height: 22),
    Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            FitQuizHelper.introFormTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          const _FieldLabel('What should we call you?'),
          const SizedBox(height: 7),
          QuizField(
            hint: 'First name',
            controller: _name,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          const _FieldLabel('And your age range?'),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final range in FitQuizHelper.ageRanges)
                QuizChip(
                  label: range,
                  isPicked: _ageRange == range,
                  onTap: () => setState(() => _ageRange = range),
                ),
            ],
          ),
        ],
      ),
    ),
    const SizedBox(height: 14),
    const Center(
      child: Text(
        FitQuizHelper.introTime,
        style: TextStyle(fontSize: 11.5, color: AppColors.inkFaint),
      ),
    ),
  ];

  // ------------------------------------------------------- standard question

  /// A list-of-answers screen. Multi-select questions pass the set their
  /// answers live in; single-answer ones are held by question id.
  List<Widget> _question(QuizQuestion question, {Set<String>? picked}) {
    bool isPicked(String value) =>
        picked == null ? _single[question.id] == value : picked.contains(value);

    void onTap(String value) {
      if (picked != null) {
        _toggleMulti(picked, question, value);
        return;
      }
      setState(() => _single[question.id] = value);
    }

    return [
      QuizHeading(title: question.title, sub: question.sub),
      const SizedBox(height: 14),
      WhyWeAsk(text: question.whyWeAsk),
      const SizedBox(height: 18),
      ...switch (question.layout) {
        QuizLayout.rows => [
          for (final option in question.options) ...[
            OptionRow(
              option: option,
              isPicked: isPicked(option.value),
              onTap: () => onTap(option.value),
            ),
            const SizedBox(height: 9),
          ],
        ],
        QuizLayout.photos => [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.82,
            children: [
              for (final option in question.options)
                if (option.imageAsset != null)
                  PhotoOption(
                    option: option,
                    isPicked: isPicked(option.value),
                    onTap: () => onTap(option.value),
                  ),
            ],
          ),
          const SizedBox(height: 10),
          // The catch-all has no photograph, so it sits under the grid as a
          // row rather than being squeezed into a tile.
          for (final option in question.options)
            if (option.imageAsset == null)
              OptionRow(
                option: option,
                isPicked: isPicked(option.value),
                onTap: () => onTap(option.value),
              ),
        ],
        QuizLayout.swatches => [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.95,
            children: [
              for (final option in question.options)
                SwatchOption(
                  option: option,
                  isPicked: isPicked(option.value),
                  onTap: () => onTap(option.value),
                ),
            ],
          ),
        ],
      },
      if (question.footnote != null) ...[
        const SizedBox(height: 6),
        InfoBanner(
          text: question.footnote!,
          iconAsset: question.footnoteIconAsset,
          // The supplied mark is a shield in the accent, so the note takes
          // the accent too rather than pairing pink artwork with green.
          tone: question.footnoteIconAsset == null
              ? null
              : AppColors.wizardSelectedBorderColor,
        ),
      ],
    ];
  }

  // --------------------------------------------------------------- q2 matrix

  List<Widget> _matrixPage() => [
    const QuizHeading(
      title: FitQuizHelper.matrixTitle,
      sub: FitQuizHelper.matrixSub,
    ),
    const SizedBox(height: 14),
    const WhyWeAsk(text: FitQuizHelper.matrixWhy),
    const SizedBox(height: 18),
    for (final product in FitQuizHelper.matrixProducts) ...[
      MatrixCard(
        product: product,
        stance: _matrix[product.value],
        onStance: (i) => setState(() {
          // Tapping the stance it already holds clears it, so an answer given
          // by accident can be taken back.
          _matrix[product.value] == i
              ? _matrix.remove(product.value)
              : _matrix[product.value] = i;
        }),
      ),
      const SizedBox(height: 9),
    ],
  ];

  // ------------------------------------------------------------------ q7 fit

  /// Only one dropdown stands open at a time, so the panels never stack up.
  void _toggleDropdown(String id) {
    setState(() => _openDropdown = _openDropdown == id ? null : id);
  }

  List<Widget> _fit() => [
    const QuizHeading(title: FitQuizHelper.fitTitle, sub: FitQuizHelper.fitSub),
    const SizedBox(height: 14),
    const WhyWeAsk(text: FitQuizHelper.fitWhy),
    const SizedBox(height: 16),
    _FitCard(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final size in FitQuizHelper.fitSizes)
              QuizChip(
                label: size,
                isPicked: _size == size,
                onTap: () => setState(() => _size = size),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FitQuizHelper.fitPantHint,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    FitQuizHelper.fitPantSub,
                    style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizeGuideLink(onTap: () => FitGuideSheet.open(context)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: Text(
                FitQuizHelper.fitPantSelect,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            const Text(
              FitQuizHelper.fitPantUnits,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.inkFaint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        QuizDropdown(
          placeholder: FitQuizHelper.fitPantPlaceholder,
          value: _pantSize,
          isOpen: _openDropdown == 'pant',
          onTap: () => _toggleDropdown('pant'),
        ),
        if (_openDropdown == 'pant') ...[
          const SizedBox(height: 8),
          PantSizePanel(
            value: _pantSize,
            onSelect: (row) => setState(() {
              _pantSize = row.label;
              // Picking off the guide answers the size question too, which is
              // the whole point of measuring.
              _size = row.size;
              _openDropdown = null;
            }),
          ),
        ],
      ],
    ),
    const SizedBox(height: 14),
    _FitCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FitQuizHelper.braTitle,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    FitQuizHelper.braSub,
                    style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizeGuideLink(onTap: () => FitGuideSheet.open(context)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _BraField(
                label: 'BAND',
                value: _braBand,
                isOpen: _openDropdown == 'band',
                onTap: () => _toggleDropdown('band'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BraField(
                label: 'CUP',
                value: _braCup,
                isOpen: _openDropdown == 'cup',
                onTap: () => _toggleDropdown('cup'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BraField(
                label: 'SIZE',
                value: _braSize,
                isOpen: _openDropdown == 'braSize',
                onTap: () => _toggleDropdown('braSize'),
              ),
            ),
          ],
        ),
        // The panel spans the card rather than the column that opened it:
        // a third of a phone's width is too narrow to tap through.
        if (_braPanel != null) ...[
          const SizedBox(height: 8),
          QuizDropdownPanel(
            options: _braPanel!.options,
            value: _braPanel!.value,
            onSelect: (v) => setState(() {
              _braPanel!.onSelect(v);
              _openDropdown = null;
            }),
          ),
        ],
      ],
    ),
  ];

  /// Which bra dropdown is open, and what it offers.
  ({List<String> options, String? value, ValueChanged<String> onSelect})?
  get _braPanel => switch (_openDropdown) {
    'band' => (
      options: FitQuizHelper.braBands,
      value: _braBand,
      onSelect: (v) => _braBand = v,
    ),
    'cup' => (
      options: FitQuizHelper.braCups,
      value: _braCup,
      onSelect: (v) => _braCup = v,
    ),
    'braSize' => (
      options: FitQuizHelper.braSizes,
      value: _braSize,
      onSelect: (v) => _braSize = v,
    ),
    _ => null,
  };

  // ------------------------------------------------------------ q8 cups/discs

  List<Widget> _cupsDiscs() => [
    const QuizHeading(
      title: FitQuizHelper.cupsTitle,
      sub: FitQuizHelper.cupsSub,
    ),
    const SizedBox(height: 14),
    const WhyWeAsk(text: FitQuizHelper.cupsWhy),
    const SizedBox(height: 18),
    const _SubHeading(FitQuizHelper.cupExperienceTitle),
    const SizedBox(height: 10),
    for (final option in FitQuizHelper.cupExperience) ...[
      OptionRow(
        option: option,
        isPicked: _cupExperience.contains(option.value),
        onTap: () => setState(() {
          _cupExperience.contains(option.value)
              ? _cupExperience.remove(option.value)
              : _cupExperience.add(option.value);
        }),
      ),
      const SizedBox(height: 9),
    ],
    const SizedBox(height: 10),
    const _SubHeading(FitQuizHelper.sexTitle),
    const SizedBox(height: 3),
    const Text(
      FitQuizHelper.sexSub,
      style: TextStyle(fontSize: 12, height: 1.45, color: AppColors.inkMuted),
    ),
    const SizedBox(height: 10),
    for (final option in FitQuizHelper.sexOptions) ...[
      OptionRow(
        option: option,
        isPicked: _sexAnswer == option.value,
        onTap: () => setState(() => _sexAnswer = option.value),
      ),
      const SizedBox(height: 9),
    ],
    if (_sexAnswer == 'skip') ...[
      const SizedBox(height: 4),
      const InfoBanner(
        text: FitQuizHelper.siliconeNotice,
        icon: Icons.info_outline_rounded,
        tone: AppColors.periwinkle,
      ),
    ],
  ];

  // -------------------------------------------------------------- q9 contact

  List<Widget> _contact() => [
    const QuizHeading(
      title: FitQuizHelper.contactTitle,
      sub: FitQuizHelper.contactSub,
    ),
    const SizedBox(height: 20),
    QuizField(
      hint: 'Name',
      controller: _name,
      icon: Icons.person_outline_rounded,
    ),
    const SizedBox(height: 12),
    QuizField(
      hint: 'Email address',
      controller: _email,
      icon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 18),
    Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuizCheckRow(
            title: FitQuizHelper.nudgeTitle,
            sub: FitQuizHelper.nudgeSub,
            isOn: _nudge,
            onTap: () => setState(() => _nudge = !_nudge),
          ),
          if (_nudge) ...[
            const SizedBox(height: 12),
            QuizField(
              hint: 'Phone number',
              controller: _phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ],
        ],
      ),
    ),
    const SizedBox(height: 16),
    QuizCheckRow(
      title: 'I accept the Terms & Conditions',
      isOn: _terms,
      onTap: () => setState(() => _terms = !_terms),
    ),
  ];

  // --------------------------------------------------------------- result

  List<Widget> _result() => [
    const SizedBox(height: 2),
    Text(
      _name.text.trim().isEmpty
          ? FitQuizHelper.resultTitle
          : '${_name.text.trim()}, meet your Saalt Stack!',
      style: const TextStyle(
        fontSize: 25,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.7,
        color: AppColors.ink,
      ),
    ),
    const SizedBox(height: 10),
    const Text(
      FitQuizHelper.resultSub,
      style: TextStyle(fontSize: 12.5, height: 1.55, color: AppColors.inkMuted),
    ),
    const SizedBox(height: 16),
    _AddAllButton(onTap: () {}),
    const SizedBox(height: 18),
    for (final pick in FitQuizHelper.stack) ...[
      StackCard(pick: pick, onAdd: () {}),
      const SizedBox(height: 10),
    ],
    const SizedBox(height: 14),
    const Text(
      FitQuizHelper.stepsTitle,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.ink,
      ),
    ),
    const SizedBox(height: 3),
    const Text(
      FitQuizHelper.stepsSub,
      style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
    ),
    const SizedBox(height: 12),
    for (final step in FitQuizHelper.steps) ...[
      QuizStepTile(step: step),
      const SizedBox(height: 9),
    ],
    const SizedBox(height: 14),
    const QuizTestimonial(
      quote: FitQuizHelper.testimonial,
      author: FitQuizHelper.testimonialAuthor,
      context_: FitQuizHelper.testimonialContext,
    ),
    const SizedBox(height: 14),
    const InfoBanner(
      text: FitQuizHelper.textIncoming,
      icon: Icons.sms_outlined,
      tone: AppColors.periwinkle,
    ),
  ];
}

/// Back button and, on the question screens, how far along you are.
class _QuizHeader extends StatelessWidget {
  const _QuizHeader({
    required this.stepNumber,
    required this.stepCount,
    required this.onBack,
  });

  final int? stepNumber;
  final int stepCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final number = stepNumber;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          CircleIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
            onTap: onBack,
          ),
          const SizedBox(width: 14),
          if (number == null)
            const Expanded(
              child: Text(
                'Find your fit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
            )
          else ...[
            Text(
              '$number/$stepCount',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.wizardSelectedBorderColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  value: number / stepCount,
                  minHeight: 6,
                  backgroundColor: AppColors.wizardSelectedBackgroundColor,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.wizardSelectedBorderColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Back, skip and the button that moves you on.
class _QuizFooter extends StatelessWidget {
  const _QuizFooter({
    required this.page,
    required this.onBack,
    required this.onNext,
    required this.onRestart,
  });

  final _Page page;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final isIntro = page == _Page.intro;
    final isResult = page == _Page.result;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              if (isResult)
                Expanded(
                  child: _GhostButton(label: 'Retake quiz', onTap: onRestart),
                )
              else ...[
                _GhostButton(
                  label: isIntro ? 'Skip' : 'Back',
                  onTap: isIntro ? onNext : onBack,
                ),
                const Spacer(),
                _PrimaryButton(
                  label: isIntro ? "Let's go" : 'Continue',
                  onTap: onNext,
                ),
              ],
              if (isResult) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _PrimaryButton(
                    label: 'Keep shopping',
                    onTap: () => context.go(AppRoutePaths.productsScreen),
                    fill: true,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.fill = false,
  });

  final String label;
  final VoidCallback onTap;

  /// Stretch to the space available rather than hugging the label.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fill ? 14 : 24,
            vertical: 14,
          ),
          child: Row(
            mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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

    return button;
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.canvas,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Grab the whole Stack at once, which is the result screen's main ask.
class _AddAllButton extends StatelessWidget {
  const _AddAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.rose,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add all to cart',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.inkMuted,
      ),
    );
  }
}

class _SubHeading extends StatelessWidget {
  const _SubHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.5,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.ink,
      ),
    );
  }
}

/// A white panel the fit step groups its fields into.
class _FitCard extends StatelessWidget {
  const _FitCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// One of the three bra fields: its small-caps label over the dropdown.
class _BraField extends StatelessWidget {
  const _BraField({
    required this.label,
    required this.value,
    required this.isOpen,
    required this.onTap,
  });

  final String label;
  final String? value;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.inkFaint,
          ),
        ),
        const SizedBox(height: 6),
        QuizDropdown(
          placeholder: 'Select',
          value: value,
          isOpen: isOpen,
          onTap: onTap,
        ),
      ],
    );
  }
}
