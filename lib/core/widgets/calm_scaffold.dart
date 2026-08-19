import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Shared screen chrome for the app: a calm background, an optional transparent
/// centered app bar, and a body wrapped in [SafeArea] with comfortable default
/// horizontal padding.
///
/// The app bar only appears when there is something to show — a [title],
/// a back button ([showBack]), or [actions].
class CalmScaffold extends StatelessWidget {
  const CalmScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBack = false,
    this.padding,
  });

  /// Main screen content.
  final Widget body;

  /// Optional centered app-bar title.
  final String? title;

  /// Optional trailing app-bar actions.
  final List<Widget>? actions;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// When true, shows a back button that pops the current route.
  final bool showBack;

  /// Body padding. Defaults to horizontal [AppSpacing.lg].
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final bool hasActions = actions != null && actions!.isNotEmpty;
    final bool hasAppBar = title != null || showBack || hasActions;

    return Scaffold(
      backgroundColor: c.background,
      appBar: hasAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: showBack
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: c.textPrimary,
                      onPressed: () => Navigator.of(context).maybePop(),
                    )
                  : null,
              title: title == null
                  ? null
                  : Text(
                      title!,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
              actions: hasActions ? actions : null,
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: body,
        ),
      ),
    );
  }
}
