import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryColor = Color(0xFF3F4759);

  // Neutrals
  static const canvas = Color(0xFFFAF8F6);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF2C3341);
  static const inkMuted = Color(0xFF6B7385);
  static const inkFaint = Color(0xFF9AA1B0);
  static const hairline = Color(0xFFEDE8E3);

  // Category tints, paired light background + saturated accent.
  static const roseTint = Color(0xFFF7E5E3);
  static const rose = Color(0xFFC0736A);

  static const sageTint = Color(0xFFE4EDE3);
  static const sage = Color(0xFF62855E);

  /// Success green. Sage is a product accent — grey-green and quiet — so a
  /// state that has to read as "done" at a glance gets its own, clearly
  /// green pair. Dark enough for 9.5px bold on [successTint] (5.4:1).
  static const successTint = Color(0xFFE1F4E9);
  static const success = Color(0xFF0F6E3F);

  static const apricotTint = Color(0xFFFBEBDB);
  static const apricot = Color(0xFFBC7F4C);

  static const periwinkleTint = Color(0xFFE5E9F4);
  static const periwinkle = Color(0xFF57648F);

  static const lilacTint = Color(0xFFEEE5F1);
  static const lilac = Color(0xFF83679A);

  static const tealTint = Color(0xFFDEEBEC);
  static const teal = Color(0xFF457C85);
}
