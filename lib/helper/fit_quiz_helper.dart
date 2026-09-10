import 'package:flutter/material.dart';
import 'package:saalt/models/fit_quiz.dart';
import 'package:saalt/res/app_images.dart';

/// Content for the "find your fit" quiz: the questions, the answers, and the
/// Stack it lands on.
class FitQuizHelper {
  FitQuizHelper._();

  static const introTitle = "Hey, let's find your fit.";

  static const introBody =
      'Most of us buy period care blind. You grab something off a shelf, or '
      'you fall into a review spiral at 2am, and you find out whether it '
      'works the hard way. Three wrong tries later, you are back where you '
      'started.';

  static const introBodyTwo =
      'Answer a few quick questions and we will build your Saalt Stack: the '
      'pieces that actually fit your body, your flow and your days. No '
      'guesswork, no wrong answers.';

  static const introFormTitle = 'First, the two easy ones.';

  static const introTime = 'Takes about 60 seconds.';

  static const ageRanges = [
    'Under 16',
    '16 to 18',
    '19 to 25',
    '26 to 34',
    '35 to 44',
    '45 to 54',
    '55+',
  ];

  /// Q1. The one that decides what goes in the Stack at all.
  static const shoppingFor = QuizQuestion(
    id: 'q1',
    title: 'What are you shopping for?',
    sub: 'Pick any or all that fit.',
    whyWeAsk:
        "This is the heart of it. What you're solving for decides what goes "
        'in your Stack, from period products to everyday pairs to a soft '
        'bralette.',
    pick: QuizPick.multi,
    options: [
      QuizOption(
        value: 'period',
        label: 'Period protection',
        icon: Icons.water_drop_rounded,
        iconAsset: AppImages.quizPeriodIcon,
      ),
      QuizOption(
        value: 'bladder',
        label: 'Bladder leaks (the sneeze-jump-laugh kind)',
        icon: Icons.shield_outlined,
        iconAsset: AppImages.quizBladderIcon,
      ),
      QuizOption(
        value: 'discharge',
        label: 'Everyday discharge or little leaks',
        icon: Icons.blur_on_rounded,
        iconAsset: AppImages.quizDischargeIcon,
      ),
      QuizOption(
        value: 'postpartum',
        label: 'Postpartum recovery',
        icon: Icons.child_friendly_rounded,
        iconAsset: AppImages.quizPostpartumIcon,
      ),
      QuizOption(
        value: 'sweat',
        label: 'Sweat, or just staying fresh on active days',
        icon: Icons.directions_run_rounded,
        iconAsset: AppImages.quizSweatIcon,
      ),
      QuizOption(
        value: 'peace',
        label: 'Peace of mind between cycles',
        icon: Icons.spa_rounded,
        iconAsset: AppImages.quizPeaceIcon,
      ),
      QuizOption(
        value: 'bralette',
        label: 'A soft bralette to go with it',
        icon: Icons.favorite_border_rounded,
        iconAsset: AppImages.quizBraletteIcon,
      ),
      QuizOption(
        value: 'notsure',
        label: 'Not sure yet, help me figure it out',
        icon: Icons.help_outline_rounded,
        isCatchAll: true,
        iconAsset: AppImages.quizNotSureIcon,
      ),
    ],
  );

  /// Q2. Not a list of answers but a grid: each product gets a stance.
  static const matrixTitle =
      'Which of these are you reaching for, ruling out, or wondering about?';

  static const matrixSub =
      "No judgment, we just want to know what's worked and what hasn't.";

  static const matrixWhy =
      "Knowing what you've loved, sworn off, or been meaning to try helps us "
      "recommend something you'll actually reach for.";

  static const matrixStances = [
    'Reaching for',
    'Ruling out',
    'Wondering about',
  ];

  static const matrixProducts = <MatrixProduct>[
    MatrixProduct(
      value: 'disc',
      label: 'Menstrual disc',
      icon: Icons.blur_circular_rounded,
      iconAsset: AppImages.quizDiscIcon,
    ),
    MatrixProduct(
      value: 'underwear',
      label: 'Period underwear',
      icon: Icons.checkroom_rounded,
      iconAsset: AppImages.quizUnderwearIcon,
    ),
    MatrixProduct(
      value: 'cup',
      label: 'Menstrual cup',
      icon: Icons.local_drink_rounded,
      iconAsset: AppImages.quizCupIcon,
    ),
    MatrixProduct(
      value: 'reusable_pad',
      label: 'Reusable pads',
      icon: Icons.layers_rounded,
      iconAsset: AppImages.quizPadIcon,
    ),
    MatrixProduct(
      value: 'tampon',
      label: 'Tampons',
      icon: Icons.straighten_rounded,
      iconAsset: AppImages.quizTamponIcon,
    ),
    MatrixProduct(
      value: 'disposable_pad',
      label: 'Disposable pads',
      icon: Icons.delete_outline_rounded,
      iconAsset: AppImages.quizPadIcon,
    ),
  ];

  /// Q3. Flow, scored in drops so the weight reads at a glance.
  static const flow = QuizQuestion(
    id: 'q3',
    title: 'How heavy is your flow?',
    sub: 'Go by how often you change or empty whatever you use now.',
    whyWeAsk:
        'Flow is a big factor in finding your fit. Heavier flows do better '
        'with higher-capacity options like a disc or super absorbency.',
    pick: QuizPick.single,
    options: [
      QuizOption(
        value: 'vheavy',
        label:
            "Very heavy: I'm changing every couple of hours, even with the "
            'heavy-duty stuff',
        drops: 4,
        iconAsset: AppImages.quizFlowVeryHeavyIcon,
      ),
      QuizOption(
        value: 'heavy',
        label: 'Heavy: every 2 to 4 hours on my worst days',
        drops: 3,
        iconAsset: AppImages.quizFlowHeavyIcon,
      ),
      QuizOption(
        value: 'medium',
        label: 'Medium: every 6 to 8 hours does it',
        drops: 2,
        iconAsset: AppImages.quizFlowMediumIcon,
      ),
      QuizOption(
        value: 'light',
        label: 'Light: I can usually go most of the day',
        drops: 1,
        iconAsset: AppImages.quizFlowLightIcon,
      ),
      QuizOption(
        value: 'allover',
        label: "It's all over the place",
        icon: Icons.shuffle_rounded,
        iconAsset: AppImages.quizFlowVariesIcon,
      ),
      QuizOption(
        value: 'notsure',
        label: 'Not sure',
        icon: Icons.help_outline_rounded,
        iconAsset: AppImages.quizFlowNotSureIcon,
      ),
    ],
  );

  /// Q4. Cuts, shown as photographs since that is how anyone recognises them.
  static const cuts = QuizQuestion(
    id: 'q4',
    title: 'Which underwear cuts do you reach for?',
    sub: 'Pick any you love.',
    whyWeAsk:
        'Your favorite cuts tell us which underwear styles to put front and '
        "center, so what we recommend is something you'd actually wear.",
    pick: QuizPick.multi,
    layout: QuizLayout.photos,
    options: [
      QuizOption(
        value: 'bikini',
        label: 'Bikini',
        imageAsset: 'assets/images/seamless_bikini.jpg',
      ),
      QuizOption(
        value: 'boyshort',
        label: 'Boyshort',
        imageAsset: 'assets/images/leakproof_comfort_cloudshort.jpg',
      ),
      QuizOption(
        value: 'brief',
        label: 'Brief',
        imageAsset: 'assets/images/leakproof_seamless_brief.jpg',
      ),
      QuizOption(
        value: 'highwaist',
        label: 'High waist',
        imageAsset: 'assets/images/seamless_high_waist.jpg',
      ),
      QuizOption(
        value: 'hipster',
        label: 'Hipster',
        imageAsset: 'assets/images/cotton_brief.jpg',
      ),
      QuizOption(
        value: 'thong',
        label: 'Thong',
        imageAsset: 'assets/images/leakproof_seamless_thong.jpg',
      ),
      QuizOption(
        value: 'all',
        label: "Show me everything, I'm not picky",
        icon: Icons.auto_awesome_rounded,
        isCatchAll: true,
      ),
    ],
  );

  /// Q5. Each vibe maps to a collection, which is what the sub-label says.
  static const occasion = QuizQuestion(
    id: 'q5',
    title: "What's the occasion?",
    sub: 'Pick the vibe, or a few.',
    whyWeAsk:
        'This matches you to a collection, so your underwear suits the '
        "moment, whether that's the gym, the office, or a night out.",
    pick: QuizPick.multi,
    footnote:
        'Every leakproof collection is free of PFAS and microplastics. That '
        "part's never up for debate.",
    footnoteIconAsset: AppImages.quizPfasIcon,
    options: [
      QuizOption(
        value: 'nightout',
        label: 'For a fun night out',
        sub: 'Hanky Panky+',
        icon: Icons.nightlife_rounded,
        iconAsset: AppImages.quizOccasionNightOutIcon,
      ),
      QuizOption(
        value: 'lazy',
        label: 'For lazy, do-nothing days',
        sub: 'Comfort',
        icon: Icons.weekend_rounded,
        iconAsset: AppImages.quizOccasionLazyIcon,
      ),
      QuizOption(
        value: 'everyday',
        label: 'For soft, breathable everyday basics',
        sub: 'Cotton',
        icon: Icons.wb_sunny_rounded,
        iconAsset: AppImages.quizOccasionEverydayIcon,
      ),
      QuizOption(
        value: 'fancy',
        label: 'For feeling a little fancy underneath',
        sub: 'Lace & Mesh',
        icon: Icons.diamond_outlined,
        iconAsset: AppImages.quizOccasionFancyIcon,
      ),
      QuizOption(
        value: 'seamless',
        label: 'For vanishing under leggings',
        sub: 'Seamless',
        icon: Icons.visibility_off_rounded,
        iconAsset: AppImages.quizOccasionSeamlessIcon,
      ),
      // No mark was supplied for this one, so it keeps a Material icon —
      // a sun rather than the wind it used to carry, which had become a
      // near-double of the supplied everyday-basics glyph.
      QuizOption(
        value: 'noleak',
        label: "For the days you don't need leak protection",
        sub: 'Non-Leakproof',
        icon: Icons.wb_sunny_rounded,
      ),
      QuizOption(
        value: 'trust',
        label: 'Just pick for me, I trust you',
        sub: "We'll curate the best mix across all collections",
        icon: Icons.auto_awesome_rounded,
        isCatchAll: true,
        iconAsset: AppImages.quizOccasionSurpriseIcon,
      ),
    ],
  );

  /// Q6. Palettes, drawn as the colours themselves.
  static const colourVibe = QuizQuestion(
    id: 'q6',
    title: "What's your color vibe?",
    sub: 'Choose the palette that speaks to you.',
    whyWeAsk:
        "This lets us show your match in a color you'll love and pre-fill it, "
        "so it's ready to add to your cart.",
    pick: QuizPick.single,
    layout: QuizLayout.swatches,
    options: [
      QuizOption(
        value: 'neutrals',
        label: 'Neutrals',
        colours: [Color(0xFF1A1A1A), Color(0xFF7B4F2E), Color(0xFFD4B896)],
      ),
      QuizOption(
        value: 'bold',
        label: 'Bold & bright',
        colours: [
          Color(0xFFFF2D78),
          Color(0xFFC8521A),
          Color(0xFF1B3FD8),
          Color(0xFF22D9E8),
        ],
      ),
      QuizOption(
        value: 'pastel',
        label: 'Soft and pastels',
        colours: [Color(0xFFF2A7B0), Color(0xFFC9B8D8), Color(0xFFC8DECA)],
      ),
      QuizOption(
        value: 'dealer',
        label: 'Surprise me',
        icon: Icons.auto_awesome_rounded,
      ),
    ],
  );

  /// Q7. Sizing, which is its own screen rather than a list of answers.
  static const fitTitle = "Let's get the fit right.";
  static const fitSub = "What's your usual size?";
  static const fitWhy =
      'Your size lets us recommend the exact underwear, ready to go, with no '
      'guessing and fewer returns.';

  static const fitSizes = [
    'XXS',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
    '4XL',
  ];

  static const fitPantHint = 'Not sure of your underwear size?';
  static const fitPantSub = 'Your pants size helps us get close.';
  static const fitGuideLink = 'See our size guide';

  static const fitPantSelect = 'Select your pant size';
  static const fitPantUnits = 'US SIZING';
  static const fitPantPlaceholder = 'Pant Size (US)';

  static const braTitle = 'Shopping for a bra too?';
  static const braSub = 'Add your size for better recommendations.';

  static const braBands = ['30', '32', '34', '36', '38', '40', '42', '44'];
  static const braCups = ['A', 'B', 'C', 'D', 'DD'];
  static const braSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  static const fitGuideKicker = 'Saalt fit guide';
  static const fitGuideHeading = 'Find your best fit';
  static const fitGuideNote = 'All measurements are in inches';

  /// The fit guide, as the site publishes it. Doubles as the pant-size
  /// dropdown, where each row is a pickable size.
  static const fitGuide = <FitGuideRow>[
    FitGuideRow(
      size: 'XXS',
      usPant: '0',
      waist: '23"',
      hips: '29–30"',
      uk: '0–2',
      youth: '9–10',
    ),
    FitGuideRow(
      size: 'XS',
      usPant: '0–2',
      waist: '24–25"',
      hips: '30–33"',
      uk: '4–6',
      youth: '11–12',
    ),
    FitGuideRow(
      size: 'S',
      usPant: '2–4',
      waist: '26–27"',
      hips: '33–37"',
      uk: '6–8',
      youth: '13–14',
    ),
    FitGuideRow(
      size: 'M',
      usPant: '6–8',
      waist: '27.5–29"',
      hips: '38–40"',
      uk: '13–14',
      youth: '15–16',
    ),
    FitGuideRow(
      size: 'L',
      usPant: '10–12',
      waist: '29.5–31.5"',
      hips: '41–44"',
      uk: '14–16',
    ),
    FitGuideRow(
      size: 'XL',
      usPant: '14–16',
      waist: '32.5–34.5"',
      hips: '45–46"',
      uk: '18–20',
    ),
    FitGuideRow(
      size: '2XL',
      usPant: '18–20',
      waist: '35.5–38"',
      hips: '47–50"',
      uk: '22–24',
    ),
    FitGuideRow(
      size: '3XL',
      usPant: '22–24',
      waist: '39–43"',
      hips: '51–54"',
      uk: '26–28',
    ),
    FitGuideRow(
      size: '4XL',
      usPant: '26–28',
      waist: '44–48"',
      hips: '55–58"',
      uk: '30–32',
    ),
  ];

  /// Q8. Two short questions on one screen.
  static const cupsTitle = 'A couple quick things about cups and discs.';
  static const cupsSub = 'Pick anything that sounds familiar.';
  static const cupsWhy =
      'Past cup experience and whether you want a wear-during-sex option both '
      'shape whether a cup, a disc, or both belong in your Stack.';

  static const cupExperienceTitle =
      "Since you've spent time with a cup, how'd it go?";

  static const cupExperience = <QuizOption>[
    QuizOption(
      value: 'cramped',
      label: 'It cramped me up, added pressure, or had me running to pee',
      icon: Icons.sentiment_dissatisfied_rounded,
      iconAsset: AppImages.quizCupCrampedIcon,
    ),
    QuizOption(
      value: 'pop',
      label: "Getting it to pop open felt like a magic trick I hadn't learned",
      icon: Icons.auto_fix_high_rounded,
      iconAsset: AppImages.quizCupPopIcon,
    ),
    QuizOption(
      value: 'seal',
      label: "I couldn't get it to seal, so, hello leaks",
      icon: Icons.water_damage_rounded,
      iconAsset: AppImages.quizCupSealIcon,
    ),
    QuizOption(
      value: 'low',
      label: 'It kept creeping down or sitting too low',
      icon: Icons.south_rounded,
      iconAsset: AppImages.quizCupLowIcon,
    ),
    QuizOption(
      value: 'great',
      label: 'It was great, no notes',
      icon: Icons.sentiment_very_satisfied_rounded,
      iconAsset: AppImages.quizCupGreatIcon,
    ),
    QuizOption(
      value: 'hated',
      label: "I hated it, we don't speak of it",
      icon: Icons.block_rounded,
      iconAsset: AppImages.quizCupHatedIcon,
    ),
  ];

  static const sexTitle = 'Do you want something you can wear during sex?';
  static const sexSub =
      "A disc can stay in for that, a cup can't, so this helps us steer you "
      'right.';

  static const sexOptions = <QuizOption>[
    QuizOption(
      value: 'yes',
      label: 'Yes, this matters to me',
      icon: Icons.check_circle_outline_rounded,
      iconAsset: AppImages.quizWearYesIcon,
    ),
    QuizOption(
      value: 'no',
      label: 'No, not needed',
      icon: Icons.remove_circle_outline_rounded,
      iconAsset: AppImages.quizWearNoIcon,
    ),
    QuizOption(
      value: 'skip',
      label: 'Skip',
      icon: Icons.skip_next_rounded,
      iconAsset: AppImages.quizWearSkipIcon,
    ),
  ];

  static const siliconeNotice =
      "No problem at all. We'll skip the cup and disc recommendations and "
      'focus on finding you the perfect underwear instead. Keep going, great '
      'matches are ahead.';

  /// Q9. Where the result gets sent.
  static const contactTitle =
      'Last one, pinky promise. Where do we send your match?';
  static const contactSub =
      'Pop in your email and we will send your personalized results, plus a '
      'simple plan for your first cycle with your new care.';
  static const nudgeTitle = 'Want a few helpful nudges by text too?';
  static const nudgeSub =
      'We will check in right around the time most people try something new '
      'for the first time. Totally optional, and you can stop anytime.';

  /// The result.
  static const resultTitle = 'Meet Your Saalt Stack!';
  static const resultSub =
      'We did the matchmaking. Here is your Stack: the pieces that fit you '
      'best with a quick note on why each one made the cut. Your size and '
      'color are already dialed in, so you can grab the whole set in one tap.';

  static const stack = <StackPick>[
    StackPick(
      name: 'Menstrual Disc',
      reason:
          "You're on the go and want to go longer between changes — the disc "
          "holds the most, so you're not planning your day around the "
          'nearest bathroom.',
      size: 'M',
      colour: 'Black',
      absorbency: 'Heavy',
      imageAsset: 'assets/images/menstrual_disc.jpg',
    ),
    StackPick(
      name: 'Seamless Bikini',
      reason:
          'For workouts and leggings days. Stays put when you move and '
          'disappears under everything.',
      size: 'M',
      colour: 'Black',
      absorbency: 'Heavy',
      imageAsset: 'assets/images/seamless_bikini.jpg',
    ),
    StackPick(
      name: 'Comfort Brief',
      reason:
          "For lazy, do-nothing days. The softest thing you'll own, with full "
          "backup so you can forget it's even a period day.",
      size: 'M',
      colour: 'Black',
      absorbency: 'Regular',
      imageAsset: 'assets/images/comfort_brief.jpg',
    ),
    StackPick(
      name: 'hanky panky+',
      reason:
          'For a fun night out. Signature lace that feels like lingerie, now '
          'with leakproof backup.',
      size: 'S/M',
      colour: 'Black',
      absorbency: 'Light',
      imageAsset: 'assets/images/lace_trim_brief.jpg',
    ),
  ];

  static const stepsTitle = 'Your first cycle, made simple';
  static const stepsSub = "Three steps and you're set.";

  static const steps = <QuizStepCard>[
    QuizStepCard(
      number: 'Step 01',
      name: 'Grab your set',
      detail:
          'Your disc and underwear are already matched to your size and '
          'color. One tap to add everything.',
      icon: Icons.shopping_bag_outlined,
    ),
    QuizStepCard(
      number: 'Step 02',
      name: 'Read the quick guide',
      detail:
          "We'll send you a super short how-to so nothing feels new when your "
          'cycle starts.',
      icon: Icons.menu_book_rounded,
    ),
    QuizStepCard(
      number: 'Step 03',
      name: 'Feel the difference',
      detail:
          'Give it one cycle. Most people never look back — but we are here '
          'if you have questions.',
      icon: Icons.favorite_rounded,
    ),
  ];

  static const testimonial =
      'I travel every other week for work and honestly used to dread my '
      'period overlapping with a trip. I got the disc and the seamless bikini '
      'based on the quiz — wore them through a full work trip, two flights, a '
      'dinner out — and I genuinely forgot I was on my period for most of it. '
      "That's never happened before.";

  static const testimonialAuthor = 'Jess M.';
  static const testimonialContext =
      'Disc + Seamless Bikini combo · Active traveler';

  static const textIncoming =
      "Keep an eye on your phone — we'll check in soon with your guide and a "
      'few tips for your first cycle.';
}
