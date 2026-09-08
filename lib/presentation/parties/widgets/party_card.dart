import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/widgets/party_grid_card.dart';
import 'package:saalt/res/app_colors.dart';

/// One session in the list. Carries the date, what it covers, and the one
/// action it supports: take a place, or watch it back.
class PartyCard extends StatelessWidget {
  const PartyCard({
    super.key,
    required this.party,
    required this.onAction,
    required this.onOpen,
  });

  final TmiParty party;
  final VoidCallback? onAction;

  /// Tapping the card opens the full description.
  final VoidCallback onOpen;

  bool get _isReplay => party.hasReplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBlock(party: party),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            party.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        StatusPill(party: party),
                        PartyMenu(party: party),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      party.blurb,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 12),
          _MetaRow(party: party),
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final topic in party.topics) _Topic(label: topic)],
          ),
          const SizedBox(height: 13),
          if (_isReplay)
            _ActionButton(
              label: 'Watch the replay',
              icon: Icons.play_arrow_rounded,
              isPrimary: true,
              accent: party.accent,
              onTap: onAction,
            )
          else if (party.isOver)
            // Over and unrecorded. Places left stopped mattering, and there
            // is nothing to join or watch.
            const _Note(
              label: 'This one was not recorded',
              icon: Icons.videocam_off_rounded,
            )
          else ...[
            _Capacity(party: party),
            const SizedBox(height: 12),
            _ActionButton(
              label: _actionLabel,
              icon: party.isLive ? Icons.sensors_rounded : Icons.login_rounded,
              isPrimary: true,
              accent: party.accent,
              onTap: party.isFull ? null : onAction,
            ),
          ],
        ],
      ),
    );
  }

  String get _actionLabel {
    if (party.isLive) return 'Join the room';
    return party.isFull ? 'No places left' : 'Join this session';
  }
}

/// The date, big enough to scan a list by.
class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.party});

  final TmiParty party;

  @override
  Widget build(BuildContext context) {
    final date = party.startsAt;

    return Container(
      height: 62,
      width: 56,
      decoration: BoxDecoration(
        color: party.tint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (party.isLive)
            Icon(Icons.sensors_rounded, size: 22, color: party.accent)
          else
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 21,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: party.accent,
              ),
            ),
          const SizedBox(height: 3),
          Text(
            party.isLive ? 'LIVE' : DateLabels.month(date).toUpperCase(),
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: party.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.party});

  final TmiParty party;

  @override
  Widget build(BuildContext context) {
    final when = party.hasReplay
        ? DateLabels.ago(party.startsInMinutes)
        : party.isLive
        ? 'Ends ${DateLabels.time(party.endsAt)}'
        : DateLabels.time(party.startsAt);

    return Row(
      children: [
        Icon(
          party.hasReplay ? Icons.history_rounded : Icons.schedule_rounded,
          size: 12,
          color: AppColors.inkFaint,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            when,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
        ),
        const _Dot(),
        Text(
          DateLabels.duration(party.minutes),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
        const _Dot(),
        Flexible(
          flex: 2,
          child: Text(
            party.host,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.inkFaint),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '·',
        style: TextStyle(fontSize: 11, color: AppColors.inkFaint),
      ),
    );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

/// How full the room is. A bar rather than a number, because "212 of 300" is
/// a sum nobody does while scrolling.
class _Capacity extends StatelessWidget {
  const _Capacity({required this.party});

  final TmiParty party;

  @override
  Widget build(BuildContext context) {
    final going = party.booked;
    final ratio = (going / party.capacity).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 5,
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppColors.hairline,
              valueColor: AlwaysStoppedAnimation(party.accent),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                party.isLive ? '$going in the room' : '$going going',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            // A live room is joined, not booked, so counting places left
            // there would be answering a question nobody asked.
            if (!party.isLive)
              Text(
                party.isFull
                    ? 'No places left'
                    : party.isNearlyFull
                    ? 'Only ${party.spotsLeft} left'
                    : '${party.spotsLeft} places left',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: party.isNearlyFull || party.isFull
                      ? party.accent
                      : AppColors.inkFaint,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// A statement, not a button: the footer still needs a line when there is
/// nothing to do.
class _Note extends StatelessWidget {
  const _Note({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.inkFaint),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.inkFaint,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.accent,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final background = !isEnabled
        ? AppColors.hairline
        : isPrimary
        ? AppColors.ink
        : Colors.transparent;
    final foreground = !isEnabled
        ? AppColors.inkFaint
        : isPrimary
        ? Colors.white
        : accent;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: isEnabled && !isPrimary
              ? BorderSide(color: accent, width: 1.3)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 15, color: foreground),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: foreground,
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
