import 'package:flutter/material.dart';

/// Calm-minimalist palette. Baseline tokens — Agent A (design system) may refine
/// values, but the NAMES here are the contract other files import.
class AppColors {
  AppColors._();

  // Surfaces — soft paper, not stark white.
  static const Color background = Color(0xFFF6F4EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDEAE3);

  // One muted accent (sage/teal) + a warm secondary.
  static const Color accent = Color(0xFF6B9080);
  static const Color accentSoft = Color(0xFFCCE3DE);
  static const Color secondary = Color(0xFFE0A458);

  // Text.
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF6B6B6B);

  // Gentle feedback — never harsh/shaming.
  static const Color positive = Color(0xFF6B9080);
  static const Color nudge = Color(0xFFC98A5E);

  /// Category accents (used sparingly for chips).
  static const Color gameTheory = Color(0xFF6B9080);
  static const Color math = Color(0xFF7C8AC9);
  static const Color physics = Color(0xFFC98A5E);
  static const Color lateral = Color(0xFFB08AC9);
}
