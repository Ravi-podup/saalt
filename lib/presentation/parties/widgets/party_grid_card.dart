import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/widgets/party_cover.dart';
import 'package:saalt/res/app_colors.dart';

/// Compact card for the grid: cover, what it is, when it is, and the one
/// action it supports behind the overflow menu.
class PartyGridCard extends StatelessWidget {
  const PartyGridCard({
    super.key,
    required this.party,
    required this.onAction,
    required this.onOpen,
  });

  final TmiParty party;
  final VoidCallback? onAction;

  /// Tapping the card opens the full description. The menu is design only,
  /// so this is the way to read a blurb a grid card has no room for.
  final VoidCallback onOpen;

  /// Two lines of 12.5px text on a 1.25 line height.
  static const titleHeight = 32.0;

  /// Everything below the cover: title, two meta lines, rule and action.
  static const contentHeight = 124.0;

  /// A tile is a 16:10 cover plus that block, so the grid can reserve an
  /// exact height instead of an aspect ratio that leaves slack.
  static double heightFor(double width) => width * 10 / 16 + contentHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.hairline),
      ),
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PartyCover(party: party, iconSize: 30),
                  Positioned(top: 8, left: 8, child: StatusPill(party: party)),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CoverPill(
                      label: DateLabels.duration(party.minutes),
                      icon: Icons.play_arrow_rounded,
                    ),
                  ),
                  // On the cover rather than in the footer: at two columns the
                  // footer cannot hold an action, a status and a menu without
                  // truncating all three.
                  Positioned(
                    top: 6,
                    right: 6,
                    child: PartyMenu(
                      party: party,
                      tone: Colors.white,
                      background: Colors.black.withValues(alpha: 0.38),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 10, 4, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Two lines whether the title needs them or not: the tile
                    // height is fixed, so a one-line title would otherwise leave
                    // a hole above the rule.
                    SizedBox(
                      height: titleHeight,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          party.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _when,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _attendance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.inkFaint,
                      ),
                    ),
                    const Spacer(),
                    const Divider(color: AppColors.hairline, height: 1),
                    _ActionRow(party: party, onAction: onAction),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _when {
    if (party.isLive) return 'Ends ${DateLabels.time(party.endsAt)}';
    if (party.hasReplay) return DateLabels.ago(party.startsInMinutes);
    return '${DateLabels.dayMonth(party.startsAt)} · '
        '${DateLabels.time(party.startsAt)}';
  }

  /// Registration is counted by the platform that runs the session, so this
  /// is read-only: the app never adds itself to the tally.
  String get _attendance {
    if (party.isLive) return '${party.booked} in the room';
    if (party.isOver) return '${party.booked} attended';
    return '${party.booked} registered';
  }
}

/// Just the action. The session's own state rides on the cover, because at
/// two columns a status and an action on one baseline squeeze each other into
/// ellipses.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.party, required this.onAction});

  final TmiParty party;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final action = _action;

    return Row(
      children: [
        // Intrinsic width, not Flexible: a flexible child competes with the
        // Spacer for the free space and gets only half of it, which was
        // ellipsising the label down to a single letter.
        if (action != null)
          _ActionLink(
            label: action.label,
            icon: action.icon,
            tone: action.tone,
            onTap: action.isEnabled ? onAction : null,
          ),
      ],
    );
  }

  /// What I can do about it, and what I have already done. Kept to one short
  /// word: at two columns a longer label pushes the status off the card.
  ({String label, IconData icon, Color tone, bool isEnabled})? get _action {
    if (party.isLive) {
      return (
        label: 'Join',
        icon: Icons.login_rounded,
        tone: AppColors.rose,
        isEnabled: true,
      );
    }
    if (party.hasReplay) {
      return (
        label: 'Watch',
        icon: Icons.play_arrow_rounded,
        tone: AppColors.ink,
        isEnabled: true,
      );
    }
    // Finished and unrecorded: say so rather than leaving the footer empty
    // under a rule that goes nowhere.
    if (party.isOver) {
      return (
        label: 'Not recorded',
        icon: Icons.videocam_off_rounded,
        tone: AppColors.inkFaint,
        isEnabled: false,
      );
    }
    return (
      label: party.isFull ? 'Full' : 'Join',
      icon: party.isFull ? Icons.lock_outline_rounded : Icons.add_rounded,
      tone: party.isFull ? AppColors.inkFaint : AppColors.ink,
      isEnabled: !party.isFull,
    );
  }
}

/// The session's own state, as a tinted pill. A bare label at this size was
/// getting ellipsised to "Com…", which is not a status.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.party});

  final TmiParty party;

  @override
  Widget build(BuildContext context) {
    final (label, icon, tone, tint) = _status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: tone),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
              color: tone,
            ),
          ),
        ],
      ),
    );
  }

  (String, IconData, Color, Color) get _status {
    if (party.isLive) {
      return (
        'LIVE NOW',
        Icons.sensors_rounded,
        AppColors.rose,
        AppColors.roseTint,
      );
    }
    // Anything finished reads as completed, in green, whether or not it was
    // recorded. Watchability shows up in the action and the play glyph on the
    // duration pill instead — a second status word for it just competed.
    if (party.isOver) {
      return (
        'COMPLETED',
        Icons.check_circle_rounded,
        AppColors.success,
        AppColors.successTint,
      );
    }
    return (
      'UPCOMING',
      Icons.schedule_rounded,
      AppColors.periwinkle,
      AppColors.periwinkleTint,
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({
    required this.label,
    required this.icon,
    required this.tone,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color tone;
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
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: tone),
              const SizedBox(width: 4),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: tone,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The host-side menu from the console. Design only: the entries are all
/// live to the touch and none of them act, because editing, inviting and
/// deleting belong to the platform that runs the sessions.
class PartyMenu extends StatelessWidget {
  const PartyMenu({
    super.key,
    required this.party,
    this.tone = AppColors.inkFaint,
    this.background,
  });

  final TmiParty party;

  /// Glyph colour, so the same menu works on a card and on artwork.
  final Color tone;

  /// Disc behind the glyph, for when it sits on a photograph.
  final Color? background;

  static const entries = <({String label, IconData icon})>[
    (label: 'Edit', icon: Icons.edit_outlined),
    (label: 'Duplicate', icon: Icons.copy_rounded),
    (label: 'Invite attendee', icon: Icons.person_add_alt_rounded),
    (label: 'Attendee list', icon: Icons.format_list_bulleted_rounded),
    (label: 'Manage speakers', icon: Icons.groups_2_outlined),
    (label: 'Delete', icon: Icons.delete_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'More for ${party.title}',
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      color: AppColors.surface,
      // A child rather than `icon`: the icon form carries IconButton's 48px
      // minimum target, which drew as a grey blob over the artwork.
      child: Container(
        height: 26,
        width: 26,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(Icons.more_vert_rounded, size: 15, color: tone),
      ),
      itemBuilder: (context) => [
        for (var i = 0; i < entries.length; i++)
          PopupMenuItem(
            value: i,
            height: 42,
            child: _MenuRow(
              label: entries[i].label,
              icon: entries[i].icon,
              isDestructive: entries[i].label == 'Delete',
            ),
          ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.label,
    required this.icon,
    required this.isDestructive,
  });

  final String label;
  final IconData icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final tone = isDestructive ? AppColors.rose : AppColors.ink;

    return Row(
      children: [
        Icon(icon, size: 16, color: tone),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: tone,
            ),
          ),
        ),
      ],
    );
  }
}
