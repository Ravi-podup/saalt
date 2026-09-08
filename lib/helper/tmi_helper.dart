import 'package:flutter/material.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/res/app_colors.dart';

/// The TMI Party schedule. Times are held relative to now, so the line-up
/// never reads as stale the way a hardcoded date would.
class TmiHelper {
  TmiHelper._();

  /// Set once someone has read the explainer, so a first-time hint does not
  /// nag on every visit.
  static final hideHowItWorks = ValueNotifier<bool>(false);

  static const tagline =
      'Live, unfiltered conversations about periods — the questions you would '
      'only ask a friend.';

  static const schedule = <TmiParty>[
    TmiParty(
      id: 'cups-101',
      title: 'Cups: your first one, start to finish',
      blurb:
          'Folding, insertion, the pop, removal in a public loo. Nothing is '
          'too basic for this one.',
      host: 'Saalt Care Team',
      // Twelve minutes in, so the room is live on open.
      startsInMinutes: -12,
      minutes: 60,
      topics: ['Cups', 'Beginners', 'Live demo'],
      capacity: 500,
      booked: 438,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      icon: Icons.water_drop_rounded,
      coverAsset: 'assets/images/explore_community.jpg',
    ),
    TmiParty(
      id: 'discs',
      title: 'Discs, demystified',
      blurb:
          'How a disc differs from a cup, who gets on better with which, and '
          'what nobody tells you about the tuck.',
      host: 'Saalt Care Team',
      startsInMinutes: 3060,
      minutes: 45,
      topics: ['Discs', 'Cups', 'Q&A'],
      capacity: 300,
      booked: 268,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
      icon: Icons.donut_large_rounded,
      coverAsset: 'assets/images/saalt_disc_duo.jpg',
    ),
    TmiParty(
      id: 'heavy-days',
      title: 'Leaks, heavy days and doubling up',
      blurb:
          'Absorbency in plain numbers, when to pair underwear with a cup, '
          'and how to sleep through a heavy night.',
      host: 'Saalt Care Team',
      startsInMinutes: 7320,
      minutes: 45,
      topics: ['Heavy flow', 'Underwear', 'Overnight'],
      capacity: 300,
      booked: 61,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
      icon: Icons.shield_moon_rounded,
      coverAsset: 'assets/images/leakproof_seamless_brief.jpg',
    ),
    TmiParty(
      id: 'teen-talk',
      title: 'Teen talk: the first period',
      blurb:
          'For teens and the grown-ups around them. Smaller sizing, school '
          'days, and how to start the conversation.',
      host: 'Saalt Care Team',
      startsInMinutes: 13200,
      minutes: 45,
      topics: ['Teens', 'Parents', 'Sizing'],
      // Sold out, so the booked-solid state is something the screen really
      // has to render rather than a branch nobody sees.
      capacity: 200,
      booked: 200,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
      icon: Icons.favorite_rounded,
      coverAsset: 'assets/images/saalt_teen_cup.jpg',
    ),
    TmiParty(
      id: 'pelvic-health',
      title: 'Periods and pelvic health',
      blurb:
          'Cramping, pelvic floor tension and when period pain is worth '
          'taking to a clinician.',
      host: 'Saalt Care Team with a pelvic health physio',
      startsInMinutes: -5760,
      minutes: 60,
      topics: ['Pain', 'Pelvic floor', 'Expert'],
      capacity: 400,
      booked: 356,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
      icon: Icons.self_improvement_rounded,
      replayUrl:
          'https://storageapi.podup.com/production/2851/files/files/'
          'episode-3-saalt-jessica_-new-2.mp4',
      coverAsset: 'assets/images/explore_show.jpg',
    ),
    TmiParty(
      id: 'sustainable-swaps',
      title: 'Sustainable swaps that stick',
      blurb:
          'What reusables actually save over a year, and how to make the '
          'switch without a false start.',
      host: 'Saalt Care Team',
      startsInMinutes: -15840,
      minutes: 45,
      topics: ['Sustainability', 'Cost', 'Habits'],
      capacity: 300,
      booked: 241,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
      icon: Icons.eco_rounded,
      replayUrl:
          'https://storageapi.podup.com/production/2851/files/files/'
          'episode-4_new2907.mp4',
      coverAsset: 'assets/images/saalt_cup_wash.jpg',
    ),
    TmiParty(
      id: 'sizing-clinic',
      title: 'Cup sizing clinic',
      blurb:
          'Bring your measurements and your questions. We work through '
          'sizing case by case.',
      host: 'Saalt Care Team',
      startsInMinutes: -25920,
      minutes: 60,
      topics: ['Sizing', 'Cups', 'Clinic'],
      capacity: 150,
      booked: 150,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
      icon: Icons.straighten_rounded,
      // Deliberately unrecorded: a clinic where people share measurements is
      // not something to publish afterwards.
      coverAsset: 'assets/images/saalt_soft_cup.jpg',
    ),
  ];

  /// The seeded line-up plus anything scheduled from inside the app.
  static List<TmiParty> get all => [...schedule, ...SessionStore.created.value];

  /// Running right now.
  static List<TmiParty> get live => all.where((p) => p.isLive).toList();

  /// Still to come, soonest first.
  static List<TmiParty> get upcoming =>
      all.where((p) => p.isUpcoming).toList()
        ..sort((a, b) => a.startsInMinutes.compareTo(b.startsInMinutes));

  /// Everything that has finished, recorded or not, most recent first.
  static List<TmiParty> get past =>
      all.where((p) => p.isOver).toList()
        ..sort((a, b) => b.startsInMinutes.compareTo(a.startsInMinutes));

  /// Finished and recorded, most recent first.
  static List<TmiParty> get replays =>
      all.where((p) => p.hasReplay).toList()
        ..sort((a, b) => b.startsInMinutes.compareTo(a.startsInMinutes));

  /// The hero exists to shout that something is on right now. With nothing
  /// live the screen is a plain console, which is what the schedule reads
  /// like the rest of the time.
  static TmiParty? get featured => live.firstOrNull;

  static const howItWorks = <({String title, String detail, IconData icon})>[
    (
      title: 'Find a session',
      detail: 'Browse what is live now, coming up, or on demand.',
      icon: Icons.event_available_rounded,
    ),
    (
      title: 'Turn up as you are',
      detail: 'Cameras off is normal. Most people come to listen.',
      icon: Icons.videocam_off_rounded,
    ),
    (
      title: 'Ask anything, anonymously',
      detail: 'Questions go through the chat with no name attached.',
      icon: Icons.chat_bubble_outline_rounded,
    ),
  ];
}
