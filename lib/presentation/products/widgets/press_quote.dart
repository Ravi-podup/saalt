import 'package:flutter/material.dart';
import 'package:saalt/res/app_images.dart';

class PressQuote extends StatelessWidget {
  const PressQuote({
    super.key,
    required this.leadIn,
    required this.highlight,
    required this.tailOff,
    required this.detail,
  });

  final String leadIn;

  final String highlight;

  final String tailOff;

  final String detail;

  static const _accent = Color(0xFFC95878);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        children: [
          Image.asset(AppImages.quotsImage, height: 22, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: leadIn,
              children: [
                TextSpan(
                  text: highlight,
                  style: const TextStyle(color: _accent),
                ),
                TextSpan(text: tailOff),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              height: 1.35,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.4,
              color: Color(0xff3F4759),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: Color(0xff3F4759),
            ),
          ),
          const SizedBox(height: 18),
          Image.asset(
            AppImages.katieMediaImg,
            height: 75,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox(height: 62),
          ),
        ],
      ),
    );
  }
}
