import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/calm_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/models/player_profile.dart';
import '../../data/providers.dart';

/// The player's local identity + progress summary. No accounts — this is a
/// calm, private space to set a name, pick an avatar, glance at how far you've
/// come, and (behind a confirmation) start fresh.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final progress = ref.watch(progressProvider);
    final currentLevel = ref.watch(currentLevelProvider);
    final totalLevels = ref.watch(levelsProvider).length;
    final themeMode = ref.watch(themeModeProvider);
    final c = context.palette;

    return CalmScaffold(
      title: 'Profile',
      showBack: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IdentityCard(
              name: profile.name,
              avatar: profile.avatar,
              onEdit: () => _editName(context, ref, profile.name),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel('Choose an avatar'),
            const SizedBox(height: AppSpacing.md),
            _AvatarPicker(
              selected: profile.avatar,
              onSelect: (emoji) =>
                  ref.read(profileProvider.notifier).setAvatar(emoji),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel('Your journey'),
            const SizedBox(height: AppSpacing.md),
            _StatsCard(
              currentLevel: currentLevel,
              totalLevels: totalLevels,
              solvedCount: progress.solvedCount,
              streak: progress.streak,
              onViewDetails: () => context.push(Routes.stats),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SectionLabel('Appearance'),
            const SizedBox(height: AppSpacing.md),
            _AppearancePicker(
              mode: themeMode,
              onSelect: (mode) =>
                  ref.read(themeModeProvider.notifier).setMode(mode),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: GhostButton(
                label: 'Reset progress',
                icon: Icons.restart_alt_rounded,
                onPressed: () => _confirmReset(context, ref),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Your name and avatar always stay.',
                style: GoogleFonts.nunito(fontSize: 13, color: c.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  /// Opens a small dialog with the current name prefilled. On Save the trimmed
  /// value is handed to the controller, which ignores empty input.
  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          final c = context.palette;
          return AlertDialog(
            backgroundColor: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
            title: Text(
              'What should we call you?',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => Navigator.of(context).pop(value),
              style: GoogleFonts.nunito(fontSize: 16, color: c.textPrimary),
              cursorColor: c.accent,
              decoration: InputDecoration(
                hintText: 'Your name',
                filled: true,
                fillColor: c.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  borderSide: BorderSide(color: c.accent),
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            actions: [
              GhostButton(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
              PrimaryButton(
                label: 'Save',
                onPressed: () => Navigator.of(context).pop(controller.text),
              ),
            ],
          );
        },
      );

      if (result != null) {
        ref.read(profileProvider.notifier).setName(result);
      }
    } finally {
      controller.dispose();
    }
  }

  /// Destructive: clears solved puzzles + streak. Only fires on explicit
  /// confirmation; name and avatar are untouched.
  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final c = context.palette;
        return AlertDialog(
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          title: Text(
            'Reset progress?',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          content: Text(
            'This clears your solved puzzles and streak. '
            'Your name and avatar stay. Continue?',
            style: GoogleFonts.nunito(
              fontSize: 15,
              height: 1.5,
              color: c.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          actions: [
            GhostButton(
              label: 'Keep it',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: c.nudge,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                textStyle: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(progressProvider.notifier).reset();
    }
  }
}

/// Identity card: big avatar in an accent-soft circle + the player's name, with
/// a gentle edit affordance. The whole card is tappable too.
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.name,
    required this.avatar,
    required this.onEdit,
  });

  final String name;
  final String avatar;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return SoftCard(
      onTap: onEdit,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: c.accentSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(avatar, style: const TextStyle(fontSize: 36)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hello,',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
            color: c.accent,
            tooltip: 'Edit name',
          ),
        ],
      ),
    );
  }
}

/// A wrap of emoji avatars. The current choice is ringed and washed in accent.
class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final emoji in kAvatarChoices)
            _AvatarTile(
              emoji: emoji,
              isSelected: emoji == selected,
              onTap: () => onSelect(emoji),
            ),
        ],
      ),
    );
  }
}

class _AvatarTile extends StatelessWidget {
  const _AvatarTile({
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Semantics(
      selected: isSelected,
      button: true,
      label: 'Avatar $emoji',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? c.accentSoft : c.surfaceMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(
              color: isSelected ? c.accent : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}

/// Calm progress summary — three warm rows and an optional link to full stats.
class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.currentLevel,
    required this.totalLevels,
    required this.solvedCount,
    required this.streak,
    required this.onViewDetails,
  });

  final int currentLevel;
  final int totalLevels;
  final int solvedCount;
  final int streak;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatRow(
            icon: Icons.flag_rounded,
            label: 'Level',
            value: 'Level $currentLevel of $totalLevels',
          ),
          const _StatDivider(),
          _StatRow(
            icon: Icons.extension_rounded,
            label: 'Puzzles solved',
            value: '$solvedCount',
          ),
          const _StatDivider(),
          _StatRow(
            icon: Icons.local_fire_department_rounded,
            label: 'Streak',
            value: streak == 1 ? '1 day' : '$streak days',
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: GhostButton(
              label: 'View detailed progress',
              icon: Icons.insights_rounded,
              onPressed: onViewDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.accentSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: c.accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(fontSize: 15, color: c.textSecondary),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Divider(height: AppSpacing.md, thickness: 1, color: c.surfaceMuted);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: c.textPrimary,
        ),
      ),
    );
  }
}

/// A calm three-option picker for the app's theme mode (System / Light / Dark).
/// The active choice is washed in accent and ringed, matching the avatar
/// picker's selection style.
class _AppearancePicker extends StatelessWidget {
  const _AppearancePicker({required this.mode, required this.onSelect});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onSelect;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: _AppearanceOption(
              icon: Icons.brightness_auto_rounded,
              label: 'System',
              isSelected: mode == ThemeMode.system,
              onTap: () => onSelect(ThemeMode.system),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _AppearanceOption(
              icon: Icons.light_mode_rounded,
              label: 'Light',
              isSelected: mode == ThemeMode.light,
              onTap: () => onSelect(ThemeMode.light),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _AppearanceOption(
              icon: Icons.dark_mode_rounded,
              label: 'Dark',
              isSelected: mode == ThemeMode.dark,
              onTap: () => onSelect(ThemeMode.dark),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  const _AppearanceOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Semantics(
      selected: isSelected,
      button: true,
      label: '$label theme',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? c.accentSoft : c.surfaceMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(
              color: isSelected ? c.accent : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? c.accent : c.textSecondary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? c.textPrimary : c.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
