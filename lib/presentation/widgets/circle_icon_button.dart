import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badgeCount = 0,
    this.showDot = false,
    this.flat = false,
    this.iconColor,
    this.tooltip,
  });

  static const double size = 32;

  final IconData icon;
  final VoidCallback? onTap;

  final int badgeCount;

  final bool showDot;

  final bool flat;

  /// Overrides the default ink glyph, for buttons that signal an active state
  /// through colour. A filled glyph in ink reads as a heavy black blob.
  final Color? iconColor;

  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      button: true,
      label: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 19, color: iconColor ?? AppColors.ink),
              // if (showDot && badgeCount == 0)
              //   Positioned(
              //     top: 10,
              //     right: 11,
              //     child: Container(
              //       height: 7,
              //       width: 7,
              //       decoration: BoxDecoration(
              //         color: AppColors.rose,
              //         shape: BoxShape.circle,
              //         border: Border.all(
              //           color: flat ? AppColors.canvas : AppColors.surface,
              //           width: 1.5,
              //         ),
              //       ),
              //     ),
              //   ),
              // if (badgeCount > 0)
              //   Positioned(
              //     top: 9,
              //     right: 8,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 4),
              //       constraints: const BoxConstraints(minWidth: 15),
              //       height: 15,
              //       decoration: BoxDecoration(
              //         color: AppColors.rose,
              //         borderRadius: BorderRadius.circular(30),
              //         border: Border.all(
              //           color: flat ? AppColors.canvas : AppColors.surface,
              //           width: 1.5,
              //         ),
              //       ),
              //       child: Center(
              //         child: Text(
              //           '$badgeCount',
              //           style: const TextStyle(
              //             fontSize: 8.5,
              //             fontWeight: FontWeight.w700,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );

    // A real tooltip, not just a semantics label: it gives long-press and
    // hover help on top of the screen-reader name.
    final label = tooltip;
    if (label == null) return button;
    return Tooltip(message: label, child: button);
  }
}
