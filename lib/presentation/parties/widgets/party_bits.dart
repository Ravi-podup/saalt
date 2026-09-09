import 'package:flutter/material.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/res/app_colors.dart';

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
