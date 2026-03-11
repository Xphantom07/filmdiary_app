import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/colors.dart';
import '../core/theme/text_styles.dart';
import '../models/movie_model.dart';

/// A polished card widget displaying a single [MovieModel] entry.
///
/// Designed to be used inside a [ListView] on the Home Screen.
/// The card follows Material 3 surface styling with:
///   - A colored genre stripe on the left edge
///   - Title, director, and year info
///   - Star rating indicator
///   - Review text preview
///   - Content type badge (Movie / Web Series)
///
/// Callbacks [onTap] and [onLongPress] allow the parent screen to handle
/// navigation and context-menu actions without coupling to this widget.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onLongPress,
  });

  final MovieModel movie;

  /// Called when the user taps the card (e.g. navigate to detail screen)
  final VoidCallback? onTap;

  /// Called on long press (e.g. show delete/edit options)
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final genreColor = _genreColor(movie.genre);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Genre Color Stripe ─────────────────────────────────
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: genreColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusLG),
                      bottomLeft: Radius.circular(AppConstants.radiusLG),
                    ),
                  ),
                ),

                // ── Card Content ───────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row + content-type badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                style: AppTextStyles.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _ContentTypeBadge(type: movie.contentType),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Director + year
                        Text(
                          '${movie.director}  ·  ${movie.releaseYear}',
                          style: AppTextStyles.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Star rating
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: movie.rating,
                              itemCount: 5,
                              itemSize: 16,
                              itemBuilder: (_, __) => const Icon(
                                Icons.star_rounded,
                                color: AppColors.starRating,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.starRating,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Human-readable label for the rating
                            if (_ratingLabel(movie.rating).isNotEmpty)
                              Text(
                                '· ${_ratingLabel(movie.rating)}',
                                style: AppTextStyles.caption,
                              ),
                          ],
                        ),

                        // Review preview (only shown when a review exists)
                        if (movie.review.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            movie.review,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Footer — genre chip + date added
                        Row(
                          children: [
                            _GenreTag(genre: movie.genre, color: genreColor),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 11,
                              color: AppColors.textSecondaryLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(movie.dateAdded),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Private Helpers ────────────────────────────────────────────────────

  /// Maps a genre string to a brand color for the card stripe and tag.
  Color _genreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'action':
        return AppColors.tagAction;
      case 'drama':
        return AppColors.tagDrama;
      case 'comedy':
        return AppColors.tagComedy;
      case 'thriller':
        return AppColors.tagThriller;
      case 'horror':
        return AppColors.tagHorror;
      case 'sci-fi':
        return AppColors.tagSciFi;
      default:
        return AppColors.tagDefault;
    }
  }

  /// Returns the human-readable label for a rating value.
  String _ratingLabel(double rating) {
    final key = rating.round().clamp(1, 5);
    return AppConstants.ratingLabels[key] ?? '';
  }

  /// Formats a [DateTime] as "MMM DD, YYYY" (e.g. "Jan 05, 2025").
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = date.day.toString().padLeft(2, '0');
    return '${months[date.month - 1]} $d, ${date.year}';
  }
}

// ─── Sub-Widgets ────────────────────────────────────────────────────────────

/// Small pill-shaped genre label that appears at the bottom of each card.
class _GenreTag extends StatelessWidget {
  const _GenreTag({required this.genre, required this.color});

  final String genre;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        genre,
        style: AppTextStyles.label.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

/// Small badge (top-right of card) showing the content type.
class _ContentTypeBadge extends StatelessWidget {
  const _ContentTypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        type,
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          fontSize: 9,
        ),
      ),
    );
  }
}
