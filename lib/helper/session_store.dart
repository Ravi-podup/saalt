import 'package:flutter/foundation.dart';
import 'package:saalt/models/tmi_party.dart';

/// Sessions scheduled from inside the app, held alongside the seeded line-up.
///
/// In memory only, like everything else here: a scheduled session survives
/// navigation but not a restart.
class SessionStore {
  SessionStore._();

  static final created = ValueNotifier<List<TmiParty>>([]);

  static void add(TmiParty party) => created.value = [...created.value, party];

  static void remove(String id) =>
      created.value = created.value.where((p) => p.id != id).toList();

  static bool isCreated(String id) => created.value.any((p) => p.id == id);

  @visibleForTesting
  static void clear() => created.value = [];
}
