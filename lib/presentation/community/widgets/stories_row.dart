import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// One bubble in the stories strip.
class Storyteller {
  const Storyteller({
    required this.name,
    required this.imageAsset,
    this.isOnline = false,
  });

  final String name;
  final String imageAsset;

  /// Draws the green dot on the corner of the tile.
  final bool isOnline;
}

class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key, required this.people, this.onAdd, this.onOpen});

  static const _tileSize = 64.0;
  static const _radius = 20.0;

  final List<Storyteller> people;
  final VoidCallback? onAdd;
  final ValueChanged<Storyteller>? onOpen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 98,
      child: ListView.separated(
        key: const Key('community-stories'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: people.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Bubble(
              label: 'Add Story',
              labelColour: Color(0xffC95878),
              fontWeight: FontWeight.w600,
              onTap: onAdd,
              child: const _AddTile(),
            );
          }
          final person = people[index - 1];
          return _Bubble(
            label: person.name,
            fontWeight: FontWeight.w400,
            onTap: () => onOpen?.call(person),
            labelColour: Color(0xff222222),
            child: _Avatar(person: person),
          );
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.label,
    required this.child,
    required this.fontWeight,
    this.labelColour,
    this.onTap,
  });

  final String label;
  final Widget child;
  final Color? labelColour;
  final FontWeight fontWeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: StoriesRow._tileSize,
          child: Column(
            children: [
              child,
              const SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: fontWeight,
                  color: labelColour,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DashedBorder(color: AppColors.rose),
      child: Container(
        height: StoriesRow._tileSize,
        width: StoriesRow._tileSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(StoriesRow._radius),
        ),
        child: Image.asset("assets/icons/add_dark_ic.png", height: 20),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.person});

  final Storyteller person;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StoriesRow._tileSize,
      width: StoriesRow._tileSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: StoriesRow._tileSize,
            width: StoriesRow._tileSize,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(StoriesRow._radius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(StoriesRow._radius - 2),
              child: Image.asset(
                person.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: AppColors.hairline),
              ),
            ),
          ),
          if (person.isOnline)
            Positioned(
              right: 2,
              bottom: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF3FBF6A),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A rounded rectangle drawn as a dashed outline. Flutter's Border has no
/// dash pattern, so the path is walked and stroked a segment at a time.
class _DashedBorder extends CustomPainter {
  const _DashedBorder({required this.color});

  final Color color;

  static const _radius = StoriesRow._radius;
  static const _dash = 5.0;
  static const _gap = 4.0;
  static const _strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(_radius)),
      );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = color;

    for (final metric in outline.computeMetrics()) {
      var start = 0.0;
      while (start < metric.length) {
        final end = (start + _dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        start = end + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorder old) => old.color != color;
}
