import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/colors.dart';
import '../core/theme/text_styles.dart';

/// A reusable star-rating widget used throughout the application.
///
/// Supports two modes:
///  - **Interactive** (default) — the user can drag or tap to set a rating.
///  - **Display-only** — shows the rating as read-only stars.
///
/// Usage:
/// ```dart
/// // Interactive
/// RatingWidget(
///   rating: 3.5,
///   onRatingChanged: (value) => setState(() => _rating = value),
/// )
///
/// // Display-only
/// RatingWidget.display(rating: 4.0)
/// ```
class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.itemSize = 32,
    this.readOnly = false,
    this.showLabel = true,
  });

  /// Convenience constructor for display-only mode.
  const RatingWidget.display({
    super.key,
    required this.rating,
    this.itemSize = 18,
    this.showLabel = true,
  })  : readOnly = true,
        onRatingChanged = null;

  /// Current star rating (0.0 – 5.0, half-star increments).
  final double rating;

  /// Called when the user selects a new rating. Null in display mode.
  final ValueChanged<double>? onRatingChanged;

  /// Size of each star icon.
  final double itemSize;

  /// When true, the widget ignores touch — used for detail/card displays.
  final bool readOnly;

  /// When true, shows a human-readable label next to the stars ("Good", etc.)
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Star Bar ──────────────────────────────────────────────────
        readOnly
            ? RatingBarIndicator(
                rating: rating,
                itemCount: 5,
                itemSize: itemSize,
                unratedColor: AppColors.divider,
                itemBuilder: (_, __) => const Icon(
                  Icons.star_rounded,
                  color: AppColors.starRating,
                ),
              )
            : RatingBar.builder(
                initialRating: rating,
                minRating: 0.5,
                maxRating: 5,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: itemSize,
                unratedColor: AppColors.divider,
                glow: false,
                itemBuilder: (_, __) => const Icon(
                  Icons.star_rounded,
                  color: AppColors.starRating,
                ),
                onRatingUpdate: onRatingChanged ?? (_) {},
              ),

        // ── Numeric Value ─────────────────────────────────────────────
        if (showLabel && rating > 0) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.starRating,
              fontSize: itemSize * 0.45,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _labelForRating(rating),
            style: AppTextStyles.caption.copyWith(
              fontSize: itemSize * 0.38,
            ),
          ),
        ],
      ],
    );
  }

  /// Maps a rating number to its human-readable label from constants.
  String _labelForRating(double value) {
    final key = value.round().clamp(1, 5);
    return AppConstants.ratingLabels[key] ?? '';
  }
}
