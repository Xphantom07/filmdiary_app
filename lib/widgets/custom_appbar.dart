import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/text_styles.dart';

/// A reusable AppBar for FilmDiary that respects the app's design system.
///
/// Implements [PreferredSizeWidget] so it can be used directly as
/// [Scaffold.appBar] without any wrapping widgets.
///
/// Usage:
/// ```dart
/// Scaffold(
///   appBar: CustomAppBar(title: 'FilmDiary'),
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.backgroundColor,
  });

  /// Main title displayed in the AppBar
  final String title;

  /// Optional subtitle shown below the title (e.g. "12 movies logged")
  final String? subtitle;

  /// Action widgets displayed on the right side (e.g. search, settings)
  final List<Widget>? actions;

  /// Optional custom leading widget (overrides back button)
  final Widget? leading;

  /// When true, shows a back arrow that pops the current route
  final bool showBackButton;

  /// Override the default [AppColors.primary] background
  final Color? backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(
        subtitle != null ? kToolbarHeight + 20 : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primary,
      elevation: 0,
      centerTitle: false,
      // Leading — back button or custom widget
      automaticallyImplyLeading: showBackButton,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      // Title column — supports optional subtitle
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyles.appBarTitle),
          if (subtitle != null) ...[
            const SizedBox(height: 1),
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
    );
  }
}
