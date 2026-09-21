import 'package:flutter/material.dart';
import 'package:saalt/helper/session_store.dart';
import 'package:saalt/helper/tmi_helper.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/wizard/webinar_wizard_screen.dart';
import 'package:saalt/presentation/parties/widgets/party_card.dart';
import 'package:saalt/presentation/parties/widgets/party_hero.dart';
import 'package:saalt/presentation/widgets/video_player_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
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
  onDemand('On-Demand');

  const PartyFilter(this.label);

  final String label;
}

class _TmiPartiesScreenState extends State<TmiPartiesScreen> {
  PartyFilter _filter = PartyFilter.all;

  /// Only a live room earns the hero; the rest of the time this is a console.
  TmiParty? get _live => TmiHelper.featured;

  /// Joining is the platform's job, not the app's, so the only thing this
  /// can carry out on its own is playing a recording back.
  void _act(TmiParty party) {
    if (party.hasReplay) _watchReplay(party);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _PartiesHeader(
              onBack: () => context.pop(),
              onSchedule: _scheduleSession,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  TmiHelper.hideHowItWorks,
                  SessionStore.created,
                ]),
                builder: (context, _) {
                  final live = _live;

                  return ListView(
                    key: const Key('parties-body'),
                    padding: EdgeInsets.only(top: 2, bottom: 28),
                    // padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
                    children: [
                      if (live != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PartyHero(
                            party: live,
                            onAction: () => _act(live),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                      _Controls(
                        filter: _filter,
                        total: 4,
                        onFilter: (f) => setState(() => _filter = f),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PartyCard(),
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

/// The session count and the filter chips.
class _Controls extends StatelessWidget {
  const _Controls({
    required this.filter,
    required this.total,
    required this.onFilter,
  });

  final PartyFilter filter;

  /// How many sessions are listed below.
  final int total;

  final ValueChanged<PartyFilter> onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Text(
            '$total Active ${total == 1 ? 'Session' : 'Sessions'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.inkDeep,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                key: const Key('parties-filters'),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 12, right: 20),
                itemCount: PartyFilter.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final option = PartyFilter.values[index];
                  return _Chip(
                    label: option.label,
                    isActive: option == filter,
                    onTap: () => onFilter(option),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
        color: isActive ? AppColors.blackColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppColors.ink : AppColors.hairline,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive ? Colors.white : Color(0xff4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartiesHeader extends StatelessWidget {
  const _PartiesHeader({this.onBack, this.onSchedule});

  final VoidCallback? onBack;
  final VoidCallback? onSchedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          BackButtonWidget(onTap: onBack),
          const Expanded(
            child: Text(
              'TMI Parties',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.inkDeep,
              ),
            ),
          ),
          InkWell(
            onTap: onSchedule,
            child: Image.asset(AppImages.addCircleIcon, height: 40),
          ),
          const SizedBox(width: 6),
          Image.asset(
            AppImages.profilePictureCircleImage,
            height: 40,
            width: 40,
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const BackButtonWidget({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 19,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
