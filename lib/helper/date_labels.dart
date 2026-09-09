class DateLabels {
  DateLabels._();

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String weekday(DateTime d) => _weekdays[d.weekday - 1];

  static String month(DateTime d) => _months[d.month - 1];

  /// '10 Sep'
  static String dayMonth(DateTime d) => '${d.day} ${month(d)}';

  /// 'Wed 10 Sep'
  static String weekdayDayMonth(DateTime d) => '${weekday(d)} ${dayMonth(d)}';

  /// '6:00 pm', which is how a session time is read aloud.
  static String time(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${d.hour < 12 ? 'am' : 'pm'}';
  }

  /// How far off something is, in the largest unit that still reads naturally.
  /// Past times come back as 'Ended'.
  static String countdown(int minutes) {
    if (minutes <= 0) return 'Ended';
    if (minutes < 60) return 'In $minutes min';
    if (minutes < 60 * 24) {
      final hours = minutes ~/ 60;
      return 'In $hours ${hours == 1 ? 'hour' : 'hours'}';
    }
    final days = minutes ~/ (60 * 24);
    return 'In $days ${days == 1 ? 'day' : 'days'}';
  }

  /// How long ago something finished, for a replay.
  static String ago(int minutesFromNow) {
    final past = -minutesFromNow;
    if (past < 60 * 24) {
      final hours = (past ~/ 60).clamp(1, 23);
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }
    final days = past ~/ (60 * 24);
    if (days < 14) return '$days ${days == 1 ? 'day' : 'days'} ago';
    final weeks = days ~/ 7;
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  }

  /// Minutes as a session length: '1 hr', '45 min', '1 hr 30 min'.
  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    final hourPart = '$hours hr';
    return rest == 0 ? hourPart : '$hourPart $rest min';
  }
}
