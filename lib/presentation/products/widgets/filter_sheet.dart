import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// The filters a listing can apply. Immutable so the sheet can hand back a
/// new set on Apply rather than mutating the screen's state as you tap.
class ProductFilters {
  const ProductFilters({
    this.absorbency = const {},
    this.sizes = const {},
    this.types = const {},
  });

  final Set<String> absorbency;
  final Set<String> sizes;
  final Set<String> types;

  int get count => absorbency.length + sizes.length + types.length;

  bool get isEmpty => count == 0;
}

/// Bottom sheet of filter groups. Choices are staged here and only applied on
/// Apply, so the grid does not thrash while you are still choosing.
class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.absorbencies,
    required this.sizes,
    required this.types,
    required this.initial,
  });

  final List<String> absorbencies;
  final List<String> sizes;
  final List<String> types;
  final ProductFilters initial;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<String> _absorbency = {...widget.initial.absorbency};
  late Set<String> _sizes = {...widget.initial.sizes};
  late Set<String> _types = {...widget.initial.types};

  int get _count => _absorbency.length + _sizes.length + _types.length;

  void _toggle(Set<String> set, String value) {
    setState(() => set.contains(value) ? set.remove(value) : set.add(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                if (_count > 0)
                  GestureDetector(
                    onTap: () => setState(() {
                      _absorbency = {};
                      _sizes = {};
                      _types = {};
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.inkMuted,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.types.length > 1)
                      _Group(
                        label: 'Product type',
                        values: widget.types,
                        selected: _types,
                        onToggle: (v) => _toggle(_types, v),
                      ),
                    if (widget.absorbencies.isNotEmpty)
                      _Group(
                        label: 'Absorbency',
                        values: widget.absorbencies,
                        selected: _absorbency,
                        onToggle: (v) => _toggle(_absorbency, v),
                      ),
                    if (widget.sizes.isNotEmpty)
                      _Group(
                        label: 'Size',
                        values: widget.sizes,
                        selected: _sizes,
                        onToggle: (v) => _toggle(_sizes, v),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(
                    ProductFilters(
                      absorbency: _absorbency,
                      sizes: _sizes,
                      types: _types,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      _count == 0 ? 'Show all' : 'Apply ($_count)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.label,
    required this.values,
    required this.selected,
    required this.onToggle,
  });

  final String label;
  final List<String> values;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                _Chip(
                  label: value,
                  isActive: selected.contains(value),
                  onTap: () => onToggle(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: Material(
        color: isActive ? AppColors.ink : AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? AppColors.ink : AppColors.hairline,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
