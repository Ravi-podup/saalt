import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// Segmented list/grid switch. Two icons rather than one that flips, so the
/// current mode is readable without having to guess what the icon means.
class ViewToggle extends StatelessWidget {
  const ViewToggle({super.key, required this.isGrid, required this.onChanged});

  final bool isGrid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Option(
            icon: Icons.view_agenda_outlined,
            label: 'List view',
            isActive: !isGrid,
            onTap: () => onChanged(false),
          ),
          const SizedBox(width: 2),
          _Option(
            icon: Icons.grid_view_rounded,
            label: 'Grid view',
            isActive: isGrid,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: Material(
        color: isActive ? AppColors.ink : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 28,
            width: 28,
            child: Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : AppColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}
