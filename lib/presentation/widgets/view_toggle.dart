import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Segmented list/grid switch. Two icons rather than one that flips, so the
/// current mode is readable without having to guess what the icon means.
class ViewToggle extends StatelessWidget {
  const ViewToggle({super.key, required this.isGrid, required this.onChanged});

  final bool isGrid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Option(
            asset: AppImages.listTileIcon,
            label: 'List view',
            isActive: !isGrid,
            onTap: () => onChanged(false),
          ),
          const SizedBox(width: 2),
          _Option(
            asset: AppImages.gridTileIcon,
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
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  /// The active disc the design fills behind the current view.
  static const _activeGround = Color(0xFF384252);

  final String asset;
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
        color: isActive ? _activeGround : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 32,
            width: 32,
            child: Center(
              child: Image.asset(
                asset,
                height: 15,
                color: isActive ? Colors.white : AppColors.inkMuted,
                errorBuilder: (_, _, _) => const SizedBox(width: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
