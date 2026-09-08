/// What was logged against one date.
class DayEntry {
  const DayEntry({this.flow, this.symptoms = const {}, this.mood});

  final String? flow;
  final Set<String> symptoms;
  final String? mood;

  bool get isEmpty => flow == null && symptoms.isEmpty && mood == null;

  /// Everything noted, for a one-line summary on a row that has no space for
  /// three separate fields.
  List<String> get labels => [
    if (flow != null) '$flow flow',
    if (mood != null) '$mood mood',
    ...symptoms,
  ];
}
