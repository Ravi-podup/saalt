import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/res/app_colors.dart';

/// Standard header for every screen below the dashboard: back button, the page
/// title centred, and an optional action. Shared so Products and Knowledgebase
/// stay pixel-identical.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;

  /// Optional supporting line, centred beneath the title.
  final String? subtitle;

  final VoidCallback? onBack;

  /// Optional action on the right. The slot keeps its width when empty so the
  /// title stays optically centred.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          SizedBox(
            height: CircleIconButton.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stacked rather than laid out between the buttons so the
                // title stays dead centre however wide the action group is.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CircleIconButton.size + 8,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: onBack,
                      tooltip: 'Back',
                    ),
                    const Spacer(),
                    ?trailing,
                  ],
                ),
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
            ),
          ],
        ],
      ),
    );
  }
}
