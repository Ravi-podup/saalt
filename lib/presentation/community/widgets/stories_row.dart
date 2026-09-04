import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// One bubble in the stories strip.
class Storyteller {
  const Storyteller({
    required this.name,
    required this.tint,
    required this.accent,
    this.hasUnseen = true,
  });

  final String name;
  final Color tint;
  final Color accent;

  /// Draws the accent ring that marks an unwatched story.
  final bool hasUnseen;

  String get initial => name.substring(0, 1).toUpperCase();
}

/// Horizontal strip of story bubbles, led by the viewer's own add button.
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key, required this.people, this.onAdd, this.onOpen});

  final List<Storyteller> people;
  final VoidCallback? onAdd;
  final ValueChanged<Storyteller>? onOpen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        key: const Key('community-stories'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: people.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Bubble(
              label: 'Add story',
              onTap: onAdd,
              child: const _AddCircle(),
            );
          }
          final person = people[index - 1];
          return _Bubble(
            label: person.name,
            onTap: () => onOpen?.call(person),
            child: _Avatar(person: person),
          );
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.label, required this.child, this.onTap});

  final String label;
  final Widget child;
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
          width: 62,
          child: Column(
            children: [
              child,
              const SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCircle extends StatelessWidget {
  const _AddCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.rose.withValues(alpha: 0.45)),
      ),
      child: const Icon(Icons.add_rounded, size: 24, color: AppColors.rose),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.person});

  final Storyteller person;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 58,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: person.hasUnseen ? person.accent : AppColors.hairline,
          width: person.hasUnseen ? 2 : 1,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: person.tint, shape: BoxShape.circle),
        child: Text(
          person.initial,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: person.accent,
          ),
        ),
      ),
    );
  }
}
