import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';

/// Ties the tracker to the shop: what Saalt makes for the day someone is
/// actually having.
class CareHelper {
  CareHelper._();

  /// Logged flow mapped to the absorbency that covers it. Heavy days get both
  /// Heavy and Super, since either is a fair answer.
  static const _absorbencyForFlow = <String, Set<String>>{
    'Light': {'Light'},
    'Medium': {'Regular'},
    'Heavy': {'Heavy', 'Super'},
  };

  /// Products worth putting in front of someone on a given day, newest need
  /// first. Empty means show nothing: a tracker that upsells on every screen
  /// stops being a tracker.
  static List<Product> suggestions({
    String? flow,
    required bool isBleedingDay,
    int limit = 2,
  }) {
    final wanted = _wanted(flow: flow, isBleedingDay: isBleedingDay);
    if (wanted.isEmpty) return const [];

    final matches = ProductHelper.catalog
        .where((p) => ProductHelper.offers(p, 'Absorbency', wanted))
        .toList();

    // One cup or disc and one pair of underwear beats two of the same thing:
    // they are alternatives, and showing both is the actual choice.
    final wearable = matches.where((p) => p.category == 'Underwear');
    final internal = matches.where((p) => p.category != 'Underwear');
    return [
      ...internal.take(1),
      ...wearable.take(1),
      ...matches,
    ].fold<List<Product>>([], (kept, product) {
      if (kept.length < limit && !kept.contains(product)) kept.add(product);
      return kept;
    });
  }

  /// The absorbency to look for. A logged flow wins; failing that a bleeding
  /// or expected day is assumed to be an ordinary one.
  static Set<String> _wanted({
    required String? flow,
    required bool isBleedingDay,
  }) {
    if (flow == 'None') return const {};
    final mapped = _absorbencyForFlow[flow];
    if (mapped != null) return mapped;
    return isBleedingDay ? const {'Regular'} : const {};
  }

  /// Why these are being shown, said plainly.
  static String reasonFor({String? flow, required bool isBleedingDay}) {
    if (flow != null && flow != 'None') {
      return 'For a ${flow.toLowerCase()} day';
    }
    return isBleedingDay ? 'For a period day' : '';
  }
}
