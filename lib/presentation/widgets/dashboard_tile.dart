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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffDBDBDB)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Cover(asset: item.imageAsset, item: item),
                const _Scrim(),
                Positioned(
                  left: 13,
                  top: 15,
                  child: _chipWidget(item.chipTitle),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                          // item.chipTitle == "WEBINAR"
                          //     ? AppColors.whiteColor
                          //     : AppColors.inkDeep,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                          // item.chipTitle == "WEBINAR"
                          //     ? AppColors.whiteColor
                          //     : AppColors.inkDeep,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chipWidget(String? title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.blackColor.withValues(alpha: .23)),
      ),
      child: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 1,
          color: Color(0xff626262),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// The wash the title and subtitle sit on. Starts a quarter of the way down
/// the tile and deepens to the bottom edge, so the photograph reads at the
/// top while the words stay legible over whatever is underneath them.
class _Scrim extends StatelessWidget {
  const _Scrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0x40000000), Color(0xD9000000)],
          stops: [0.25, 0.62, 1],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.asset, required this.item});

  final String asset;
  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, fit: BoxFit.cover);
  }
}
