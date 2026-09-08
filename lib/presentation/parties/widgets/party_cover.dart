import 'package:flutter/material.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/res/app_colors.dart';

/// The artwork behind a party. A photograph when the session has one, and a
/// tinted panel carrying its topic glyph when it does not — so a session
/// without a still never falls back to an unrelated product shot.
class PartyCover extends StatelessWidget {
  const PartyCover({super.key, required this.party, this.iconSize = 44});

  final TmiParty party;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final asset = party.coverAsset;

    return Stack(
      fit: StackFit.expand,
      children: [
        _Panel(party: party, iconSize: iconSize),
        if (asset != null)
          Image.asset(
            asset,
            fit: BoxFit.cover,
            // Centre, not top: most of these covers are product shots whose
            // subject sits in the middle of the frame.
            alignment: Alignment.center,
            // The panel underneath is the fallback, so a missing file costs
            // nothing but the photograph.
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.party, required this.iconSize});

  final TmiParty party;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            party.tint,
            Color.lerp(party.tint, party.accent, 0.35) ?? party.tint,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          party.icon,
          size: iconSize,
          color: party.accent.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

/// Rose dot and wordmark for a room that is running now.
class LivePill extends StatelessWidget {
  const LivePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.rose,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // A steady dot, not a pulse: a repeating animation never lets
          // pumpAndSettle finish, which would trap every test that opens
          // this screen while a room is live.
          _Dot(),
          SizedBox(width: 6),
          Text(
            'LIVE NOW',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 6,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Neutral label for a time or a topic, drawn on artwork.
class CoverPill extends StatelessWidget {
  const CoverPill({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: Colors.white),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
