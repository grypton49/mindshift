import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brightness-aware semantic palette, delivered via [ThemeExtension] so every
/// widget picks up light OR dark colors automatically. Access it in a build
/// method with `context.palette` (see the extension at the bottom).
///
/// Field names mirror [AppColors] (the light source of truth) so widgets migrate
/// from `AppColors.x` to `context.palette.x` mechanically.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.accent,
    required this.accentSoft,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.positive,
    required this.nudge,
    required this.onAccent,
    required this.gameTheory,
    required this.math,
    required this.physics,
    required this.lateral,
  });

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color accent;
  final Color accentSoft;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color positive;
  final Color nudge;

  /// Readable foreground to place ON top of [accent] (e.g. filled buttons).
  final Color onAccent;

  final Color gameTheory;
  final Color math;
  final Color physics;
  final Color lateral;

  /// The calm-minimalist light palette (reuses the existing [AppColors] values).
  static const light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceMuted: AppColors.surfaceMuted,
    accent: AppColors.accent,
    accentSoft: AppColors.accentSoft,
    secondary: AppColors.secondary,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    positive: AppColors.positive,
    nudge: AppColors.nudge,
    onAccent: Colors.white,
    gameTheory: AppColors.gameTheory,
    math: AppColors.math,
    physics: AppColors.physics,
    lateral: AppColors.lateral,
  );

  /// A calm dark palette — soft, low-contrast surfaces (not pure black), a
  /// lightened sage accent that reads on dark, and gentle text.
  static const dark = AppPalette(
    background: Color(0xFF14181A),
    surface: Color(0xFF1E2427),
    surfaceMuted: Color(0xFF2A3236),
    accent: Color(0xFF8FBFAE),
    accentSoft: Color(0xFF2C3A35),
    secondary: Color(0xFFE0A458),
    textPrimary: Color(0xFFECEFEC),
    textSecondary: Color(0xFF9FA8A5),
    positive: Color(0xFF8FBFAE),
    nudge: Color(0xFFE0A87A),
    onAccent: Color(0xFF10201A),
    gameTheory: Color(0xFF8FBFAE),
    math: Color(0xFF9AA6E0),
    physics: Color(0xFFE0A87A),
    lateral: Color(0xFFC7A6E0),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? accent,
    Color? accentSoft,
    Color? secondary,
    Color? textPrimary,
    Color? textSecondary,
    Color? positive,
    Color? nudge,
    Color? onAccent,
    Color? gameTheory,
    Color? math,
    Color? physics,
    Color? lateral,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      secondary: secondary ?? this.secondary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      positive: positive ?? this.positive,
      nudge: nudge ?? this.nudge,
      onAccent: onAccent ?? this.onAccent,
      gameTheory: gameTheory ?? this.gameTheory,
      math: math ?? this.math,
      physics: physics ?? this.physics,
      lateral: lateral ?? this.lateral,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      nudge: Color.lerp(nudge, other.nudge, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      gameTheory: Color.lerp(gameTheory, other.gameTheory, t)!,
      math: Color.lerp(math, other.math, t)!,
      physics: Color.lerp(physics, other.physics, t)!,
      lateral: Color.lerp(lateral, other.lateral, t)!,
    );
  }
}

/// `context.palette` — the active [AppPalette] for the current theme brightness.
extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
