import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/helper/tmi_helper.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/wizard/webinar_wizard_screen.dart';
import 'package:saalt/presentation/parties/widgets/party_card.dart';
import 'package:saalt/presentation/parties/widgets/party_hero.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// TMI Parties, laid out as a session console: filter by state, switch
/// between a grid and a list, and act on any session from its own card.
class TmiPartiesScreen extends StatefulWidget {
  const TmiPartiesScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.tmiPartiesScreen);
  }

  @override
  State<TmiPartiesScreen> createState() => _TmiPartiesScreenState();
}

enum PartyFilter {
  all('All'),
  live('Live'),
  upcoming('Upcoming'),
  onDemand('On-demand'),
  completed('Completed');

  const PartyFilter(this.label);

  final String label;
}

class _TmiPartiesScreenState extends State<TmiPartiesScreen> {
  PartyFilter _filter = PartyFilter.all;

  /// Only a live room earns the hero; the rest of the time this is a console.
  TmiParty? get _live => TmiHelper.featured;

  List<TmiParty> _partiesFor(PartyFilter filter) => switch (filter) {
    PartyFilter.all => _everything,
    PartyFilter.live => TmiHelper.live,
    PartyFilter.upcoming => TmiHelper.upcoming,
    // On-demand is what can be watched back; Completed is everything that has
    // finished, recorded or not. They are different questions.
    PartyFilter.onDemand => TmiHelper.replays,
    PartyFilter.completed => TmiHelper.past,
  };

  List<TmiParty> get _everything => [
    ...TmiHelper.live,
    ...TmiHelper.upcoming,
    ...TmiHelper.past,
  ];

  void _showHowItWorks() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _HowItWorksSheet(
        onDone: () {
          TmiHelper.hideHowItWorks.value = true;
          // Closes the sheet, so Navigator rather than the router.
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _act(TmiParty party) {
    if (party.hasReplay) return _watchReplay(party);
    _join(party);
  }

  /// Joining is the platform's job, not the app's. Until that link exists
  /// this says so rather than pretending a place was held.
  void _join(TmiParty party) => _toast(
    party.isLive
        ? 'Opening ${party.title}…'
        : 'Joining opens when ${party.title} starts',
  );

  void _watchReplay(TmiParty party) {
    final url = party.replayUrl;
    if (url == null) return;
    VideoPlayerScreen.open(
      context,
      title: party.title,
      subtitle: 'TMI Party replay · ${party.host}',
      url: url,
    );
  }

  void _scheduleSession() {
    WebinarWizardScreen.open(context);
  }

  /// The grid has no room for a description, so it lives one tap away.
  void _showAbout(TmiParty party) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AboutSheet(
        party: party,
        onAction: () {
          // Navigator, not context.pop: this closes a modal sheet, and the
          // router's pop would take the page underneath it instead.
          Navigator.of(context).pop();
          _act(party);
        },
      ),
    );
  }

  void _toast(String message) {
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
              title: 'TMI Parties',
              subtitle: 'Live and on-demand, hosted by Saalt',
              onBack: () => context.pop(),
              trailing: CircleIconButton(
                icon: Icons.add_rounded,
                tooltip: 'Schedule a webinar',
                onTap: _scheduleSession,
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  TmiHelper.hideHowItWorks,
                  SessionStore.created,
                ]),
                builder: (context, _) {
                  final hideExplainer = TmiHelper.hideHowItWorks.value;
                  final live = _live;
                  final parties = _partiesFor(_filter);

                  return ListView(
                    key: const Key('parties-body'),
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
                    children: [
                      if (live != null) ...[
                        PartyHero(party: live, onAction: () => _act(live)),
                        const SizedBox(height: 20),
                      ],
                      if (!hideExplainer) ...[
                        _HowItWorksBanner(
                          onTap: _showHowItWorks,
                          onDismiss: () =>
                              TmiHelper.hideHowItWorks.value = true,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _Controls(
                        filter: _filter,
                        counts: {
                          for (final f in PartyFilter.values)
                            f: _partiesFor(f).length,
                        },
                        onFilter: (f) => setState(() => _filter = f),
                      ),
                      const SizedBox(height: 14),
                      if (parties.isEmpty)
                        _Empty(filter: _filter)
                      else
                        for (final party in parties) ...[
                          PartyCard(
                            party: party,
                            onAction: () => _act(party),
                            onOpen: () => _showAbout(party),
                          ),
                          const SizedBox(height: 12),
                        ],
                      const SizedBox(height: 16),
                      const _Footnote(),
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

/// The session count and the filter chips.
class _Controls extends StatelessWidget {
  const _Controls({
    required this.filter,
    required this.counts,
    required this.onFilter,
  });

  final PartyFilter filter;
  final Map<PartyFilter, int> counts;
  final ValueChanged<PartyFilter> onFilter;

  @override
  Widget build(BuildContext context) {
    final total = counts[PartyFilter.all] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$total ${total == 1 ? 'session' : 'sessions'}',
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          key: const Key('parties-filters'),
          scrollDirection: Axis.horizontal,
          // Clipped on purpose: left unclipped, the chips that overflow paint
          // over their neighbours and cannot be tapped where they spill
          // outside the viewport.
          child: Row(
            children: [
              for (final option in PartyFilter.values) ...[
                _Chip(
                  label: option.label,
                  count: counts[option] ?? 0,
                  isActive: option == filter,
                  onTap: () => onFilter(option),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.ink : AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppColors.ink : AppColors.hairline,
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.inkMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.inkFaint,
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

/// Everything a card cannot carry: the description, the topics and the room.
class _AboutSheet extends StatelessWidget {
  const _AboutSheet({required this.party, required this.onAction});

  final TmiParty party;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                party.title,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                party.blurb,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 16),
              _Fact(
                icon: Icons.groups_2_rounded,
                label: 'Hosted by ${party.host}',
              ),
              _Fact(
                icon: Icons.event_rounded,
                label: party.isOver
                    ? 'Ran ${DateLabels.ago(party.startsInMinutes)} · '
                          '${DateLabels.duration(party.minutes)}'
                    : '${DateLabels.weekdayDayMonth(party.startsAt)} · '
                          '${DateLabels.time(party.startsAt)} · '
                          '${DateLabels.duration(party.minutes)}',
              ),
              _Fact(
                icon: Icons.confirmation_number_outlined,
                label: party.isOver
                    ? '${party.booked} attended'
                    : '${party.booked} registered of ${party.capacity} places',
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final topic in party.topics)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Text(
                        topic,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                ],
              ),
              if (_actionLabel != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Text(
                          _actionLabel!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? get _actionLabel {
    if (party.isLive) return 'Join the room';
    if (party.hasReplay) return 'Watch the replay';
    if (party.isOver) return null;
    return party.isFull ? null : 'Join this session';
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.inkFaint),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.filter});

  final PartyFilter filter;

  @override
  Widget build(BuildContext context) {
    final (title, detail) = switch (filter) {
      PartyFilter.live => (
        'Nothing on right now',
        'Sessions run most weeks — check Coming up for the next one.',
      ),
      PartyFilter.upcoming => (
        'Nothing in the diary yet',
        'New sessions are announced every few weeks.',
      ),
      PartyFilter.onDemand => (
        'Nothing to watch back yet',
        'Not every session is recorded — some are off the record on purpose.',
      ),
      PartyFilter.completed => (
        'No sessions have run yet',
        'Finished sessions are listed here, recorded or not.',
      ),

      PartyFilter.all => (
        'No sessions yet',
        'The schedule will show up here as soon as it opens.',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_rounded,
            size: 28,
            color: AppColors.inkFaint,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// One line near the top instead of a tall block at the bottom: an explainer
/// nobody scrolls to is an explainer nobody reads.
class _HowItWorksBanner extends StatelessWidget {
  const _HowItWorksBanner({required this.onTap, required this.onDismiss});

  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.roseTint,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 6, 11),
          child: Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                size: 15,
                color: AppColors.rose,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'First time? Here is how a TMI Party works.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                iconSize: 15,
                visualDensity: VisualDensity.compact,
                tooltip: 'Hide this',
                icon: const Icon(Icons.close_rounded, color: AppColors.rose),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorksSheet extends StatelessWidget {
  const _HowItWorksSheet({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final steps = TmiHelper.howItWorks;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'How a TMI Party works',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < steps.length; i++)
                _Step(
                  number: i + 1,
                  title: steps[i].title,
                  detail: steps[i].detail,
                  icon: steps[i].icon,
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: onDone,
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      child: Text(
                        'Got it',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.detail,
    required this.icon,
  });

  final int number;
  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 16, 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.roseTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: AppColors.rose),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. $title',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}

class _Footnote extends StatelessWidget {
  const _Footnote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 13, color: AppColors.inkFaint),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            'Sessions are general education, not medical advice. Joining '
            'happens on the Saalt session platform.',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.4,
              color: AppColors.inkFaint,
            ),
          ),
        ),
      ],
    );
  }
}
