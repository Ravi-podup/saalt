import 'package:flutter/material.dart';
import 'package:saalt/models/dashboard_item.dart';
import 'package:saalt/res/app_colors.dart';

class DashboardTile extends StatefulWidget {
  const DashboardTile({super.key, required this.item, this.onTap});

  final DashboardItem item;
  final VoidCallback? onTap;

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Semantics(
      button: true,
      label: '${item.title}. ${item.subtitle}',
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.tint,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: item.accent.withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(item.icon, size: 22, color: item.accent),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: item.accent.withValues(alpha: 0.55),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    color: AppColors.ink.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
