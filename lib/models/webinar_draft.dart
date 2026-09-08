import 'package:flutter/material.dart';
import 'package:saalt/models/session_look.dart';

/// One speaker on the draft.
class SpeakerDraft {
  SpeakerDraft({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.jobTitle = '',
    this.company = '',
    this.role = SpeakerRole.host,
  });

  String firstName;
  String lastName;
  String email;
  String jobTitle;
  String company;
  SpeakerRole role;

  String get name => '$firstName $lastName'.trim();
}

enum SpeakerRole {
  host('Host', 'Full control', Icons.workspace_premium_rounded),
  presenter('Presenter', 'Can present', Icons.co_present_rounded),
  panelist('Panelist', 'Q&A only', Icons.groups_2_rounded);

  const SpeakerRole(this.label, this.detail, this.icon);

  final String label;
  final String detail;
  final IconData icon;

  /// Defaults applied when a role is picked, overridable per speaker.
  Map<String, bool> get permissions => switch (this) {
    SpeakerRole.host => {
      'Audio': true,
      'Video': true,
      'Screen': true,
      'Group chat': true,
      'Create polls': true,
      'Start webinar': true,
    },
    SpeakerRole.presenter => {
      'Audio': true,
      'Video': true,
      'Screen': true,
      'Group chat': true,
      'Create polls': false,
      'Start webinar': false,
    },
    SpeakerRole.panelist => {
      'Audio': true,
      'Video': false,
      'Screen': false,
      'Group chat': true,
      'Create polls': false,
      'Start webinar': false,
    },
  };
}

/// Everything the wizard collects. Held in memory for the length of the flow.
class WebinarDraft {
  WebinarDraft();

  /// Places the chosen audience bucket stands for.
  int get capacity => switch (audience) {
    '1–50' => 50,
    '51–200' => 200,
    '201–500' => 500,
    _ => 1000,
  };

  // Step 1 — setup
  bool startsImmediately = false;
  DateTime? date;
  TimeOfDay? time;
  String timeZone = 'India Standard Time (IST)';
  String title = '';
  final objectives = <String>['', '', ''];
  String description = '';
  bool isPaid = false;
  bool isLive = true;
  int minutes = 60;
  String language = 'English';
  String audience = '1–50';
  bool requiresApproval = false;
  bool hasWaitingRoom = false;
  SessionLook look = sessionLooks.first;

  // The brief, gathered on its own screen and carried into the fields above.
  String about = '';
  String goal = '';
  String? briefAudience;
  String? level;
  String? tone;

  static const audiences = [
    'First-time users',
    'Teens',
    'Parents',
    'Heavy flow',
    'Athletes',
    'Everyone',
  ];
  static const levels = [
    'New to cups',
    'Some experience',
    'Confident',
    'All levels',
  ];
  static const tones = ['Warm', 'Practical', 'Playful', 'Clinical'];

  /// True once the brief screen has anything worth carrying over.
  bool get hasBrief =>
      about.trim().isNotEmpty ||
      goal.trim().isNotEmpty ||
      briefAudience != null ||
      level != null ||
      tone != null;

  /// What the brief says, for the summary line on the setup step.
  List<String> get briefTags => [?briefAudience, ?level, ?tone];

  /// Carries the brief into the fields it can legitimately fill. Titles and
  /// full descriptions are not generated: there is no model behind this, and
  /// inventing copy would be worse than leaving it blank.
  void applyBrief() {
    if (about.trim().isNotEmpty && description.trim().isEmpty) {
      description = about.trim();
    }
    if (goal.trim().isNotEmpty && objectives.first.trim().isEmpty) {
      objectives[0] = goal.trim();
    }
  }

  // Step 2 — speakers
  final speakers = <SpeakerDraft>[];

  // Step 3 — emails
  final speakerEmails = <String, bool>{
    'Invitation email': true,
    'Reminder email': true,
  };
  final attendeeEmails = <String, bool>{
    'Invite email': true,
    'Reminder email': true,
    'Registration confirmation': true,
  };

  // Step 4 — thumbnail
  String thumbnailPlatform = 'Webinar';
  double zoom = 1.75;
  double titleSize = 100;
  String textPosition = 'Bottom';
  String textStyle = 'Dark';

  // Step 7 — stream destinations
  final destinations = <String, bool>{'YouTube': false, 'Twitch': false};

  static const audienceSizes = ['1–50', '51–200', '201–500', '500+'];
  static const durations = [30, 45, 60, 90];
  static const languages = ['English', 'Hindi', 'Spanish', 'French'];

  DateTime? get startsAt {
    final d = date;
    final t = time;
    if (d == null || t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  bool get isTitleReady => title.trim().length >= 4;

  bool get isScheduleReady => startsImmediately || startsAt != null;

  /// Only the parts a card actually needs to exist.
  bool get canFinish => isTitleReady && isScheduleReady;
}
