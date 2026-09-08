import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/widgets/party_cover.dart';
import 'package:saalt/res/app_colors.dart';

/// The session the screen opens on: whatever is live, or the next one in the
/// diary. Everything needed to decide to turn up sits on this one card.
class PartyHero extends StatelessWidget {
  const PartyHero({super.key, required this.party, required this.onAction});

  final TmiParty party;

  /// Joins the room. The hero only appears while something is live.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 336,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PartyCover(party: party, iconSize: 72),
            const _Scrim(),
            Positioned(
              top: 14,
              left: 14,
              child: party.isLive
                  ? const LivePill()
                  : CoverPill(
                      label: DateLabels.countdown(party.startsInMinutes),
                      icon: Icons.schedule_rounded,
                    ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: CoverPill(label: DateLabels.duration(party.minutes)),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Line(
                      icon: Icons.groups_2_rounded,
                      text: 'Hosted by ${party.host}',
                    ),
                    const SizedBox(height: 5),
                    _Line(
                      icon: Icons.event_rounded,
                      text: party.isLive
                          ? 'Started ${DateLabels.time(party.startsAt)} · '
                                'ends ${DateLabels.time(party.endsAt)}'
                          : '${DateLabels.weekdayDayMonth(party.startsAt)} · '
                                '${DateLabels.time(party.startsAt)}',
                    ),
                    const SizedBox(height: 14),
                    _Cta(party: party, onTap: onAction),
                    const SizedBox(height: 9),
                    Text(
                      _attendance,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _attendance {
    if (party.isLive) return '${party.booked} in the room';
    if (party.isFull) return '${party.booked} registered · no places left';
    return '${party.booked} registered · ${party.spotsLeft} '
        '${party.spotsLeft == 1 ? 'place' : 'places'} left';
  }
}

class _Scrim extends StatelessWidget {
  const _Scrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0x33000000), Color(0xD9000000)],
          stops: [0, 0.38, 1],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.8)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ),
      ],
    );
  }
}

class _Cta extends StatelessWidget {
  const _Cta({required this.party, this.onTap});

  final TmiParty party;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isBlocked = !party.isLive && party.isFull;

    final label = party.isLive
        ? 'Join the room'
        : isBlocked
        ? 'No places left'
        : 'Join this session';

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isBlocked ? Colors.white.withValues(alpha: 0.3) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: isBlocked ? null : onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  party.isLive
                      ? Icons.sensors_rounded
                      : isBlocked
                      ? Icons.lock_outline_rounded
                      : Icons.login_rounded,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
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
