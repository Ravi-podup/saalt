import 'package:flutter/material.dart';

/// One TMI Party: a live, hosted conversation people book a place in.
class TmiParty {
  const TmiParty({
    required this.id,
    required this.title,
    required this.blurb,
    required this.host,
    required int startsInMinutes,
    required this.minutes,
    this.scheduledAt,
    required this.topics,
    required this.capacity,
    required this.booked,
    required this.tint,
    required this.accent,
    required this.icon,
    this.coverAsset,
    this.replayUrl,
  }) : _offsetMinutes = startsInMinutes;

  /// A session someone scheduled, pinned to a real date rather than an offset
  /// from whenever the app happens to be open.
  factory TmiParty.scheduled({
    required String id,
    required String title,
    required String blurb,
    required String host,
    required DateTime startsAt,
    required int minutes,
    required List<String> topics,
    required int capacity,
    required Color tint,
    required Color accent,
    required IconData icon,
  }) {
    return TmiParty(
      id: id,
      title: title,
      blurb: blurb,
      host: host,
      startsInMinutes: 0,
      scheduledAt: startsAt,
      minutes: minutes,
      topics: topics,
      capacity: capacity,
      booked: 0,
      tint: tint,
      accent: accent,
      icon: icon,
    );
  }

  final String id;
  final String title;

  /// One line on what the session actually covers.
  final String blurb;

  /// Who runs it. Role-based rather than a named person, since the real
  /// line-up is not something this app knows.
  final String host;

  final int _offsetMinutes;

  /// Set for scheduled sessions. Null for the seeded line-up, which is held
  /// as an offset so the demo schedule never reads as stale.
  final DateTime? scheduledAt;

  /// Minutes from now until the doors open. Negative means it has started.
  /// Counted from [scheduledAt] when there is one, so a real date does not
  /// slide forward as the app stays open.
  int get startsInMinutes =>
      scheduledAt?.difference(DateTime.now()).inMinutes ?? _offsetMinutes;

  /// How long the session runs.
  final int minutes;

  final List<String> topics;

  final int capacity;

  /// Places already taken, before this user books one.
  final int booked;

  final Color tint;
  final Color accent;

  /// Drawn on the cover when there is no photograph for the session.
  final IconData icon;

  final String? coverAsset;

  /// Watchable once the session is over.
  final String? replayUrl;

  DateTime get startsAt =>
      scheduledAt ?? DateTime.now().add(Duration(minutes: _offsetMinutes));

  DateTime get endsAt => startsAt.add(Duration(minutes: minutes));

  /// Running right now, so the call can be joined rather than booked.
  bool get isLive => startsInMinutes <= 0 && startsInMinutes + minutes > 0;

  bool get isOver => startsInMinutes + minutes <= 0;

  bool get isUpcoming => startsInMinutes > 0;

  /// A finished session is only watchable if it was recorded.
  bool get hasReplay => isOver && replayUrl != null;

  int get spotsLeft => capacity - booked;

  bool get isFull => spotsLeft <= 0;

  /// How full the room is, for the capacity bar.
  double get fillRatio => (booked / capacity).clamp(0.0, 1.0);

  /// True when there are few enough places left to be worth saying so.
  bool get isNearlyFull => !isFull && spotsLeft <= capacity * 0.15;
}
