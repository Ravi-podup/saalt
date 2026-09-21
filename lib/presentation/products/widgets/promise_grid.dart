import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class PromiseGrid extends StatelessWidget {
  const PromiseGrid({super.key});

  static const _accent = Color(0xFFC95878);

  static const _promises =
      <({String icon, String claim, String label, String detail})>[
        (
          icon: AppImages.guaranteeIcon,
          claim: '90-Day',
          label: 'GUARANTEE',
          detail: 'Risk-free promise, always',
        ),
        (
          icon: AppImages.lessIcon,
          claim: 'Less',
          label: 'WASTE',
          detail: 'Eco-friendly & reusable',
        ),
        (
          icon: AppImages.like1FillIcon,
          claim: 'Ultra',
          label: 'COMFORT',
          detail: 'Feels like regular underwear',
        ),
        (
          icon: AppImages.save1Icon,
          claim: 'Save',
          label: 'YOUR WALLET',
          detail: 'Cut monthly period costs',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'No waste. No leaks. No worries.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.4,
            color: Color(0xff3F4759),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'We are on a mission to end panicked sprints to the bathroom, '
          'sweaters tied around waists, and sleeping on towels.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Color(0xff374151),
          ),
        ),
        const SizedBox(height: 18),
        for (var i = 0; i < _promises.length; i += 2) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _Tile(promise: _promises[i])),
                const SizedBox(width: 12),
                Expanded(child: _Tile(promise: _promises[i + 1])),
              ],
            ),
          ),
          if (i + 2 < _promises.length) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.promise});

  final ({String icon, String claim, String label, String detail}) promise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE8DDD4)),
        // Two shadows: a tight black one for the lift, and a wider warm
        // one so the tiles sit on the beige rather than float over it.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: const Color(0xFFB5714A).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffC95878).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xffC95878).withValues(alpha: .18),
                  ),
                ),
                child: Image.asset(promise.icon, height: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  promise.claim,
                  // maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: PromiseGrid._accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: promise.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Color(0xff374151),
              ),
              children: [
                TextSpan(
                  text: '  ${promise.detail}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    // letterSpacing: 0,
                    color: Color(0xff64748B),
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 10, height: 1.4),
          ),
        ],
      ),
    );
  }
}
