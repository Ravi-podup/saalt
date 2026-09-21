import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/circle_icon_button.dart';
import 'package:saalt/res/app_colors.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  final VoidCallback? onBack;

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
                      fontWeight: FontWeight.w400,
                      color: AppColors.inkDeep,
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

class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 19,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
