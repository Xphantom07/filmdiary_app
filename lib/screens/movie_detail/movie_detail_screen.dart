import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../models/movie_model.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/rating_widget.dart';

/// Full-screen detail view for a single movie or series.
///
/// Receives a `MovieModel` via the route arguments.
/// Provides action buttons to **Edit** or **Delete** the entry.
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});

  /// The movie entry to display.
  final MovieModel movie;

  // ─── Delete Flow ───────────────────────────────────────────────────────

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        title: Text('Delete Entry', style: AppTextStyles.title),
        content: Text(
          'Are you sure you want to delete "${movie.title}"?\nThis action cannot be undone.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await HiveService().deleteMovie(movie.id);
      if (context.mounted) {
        Navigator.of(context).pop(true); // signal home to refresh
      }
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: movie.title,
        showBackButton: true,
        actions: [
          // ── Edit ──
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updated = await Navigator.of(context).pushNamed(
                AppRoutes.editMovie,
                arguments: movie,
              );
              if (updated == true && context.mounted) {
                // Pop detail screen too so home reloads fresh data
                Navigator.of(context).pop(true);
              }
            },
          ),
          // ── Delete ──
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Poster / Hero Banner ──────────────────────────────
            _PosterSection(posterUrl: movie.posterUrl),

            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ───────────────────────────────────────
                  Text(movie.title, style: AppTextStyles.headline1),
                  const SizedBox(height: 4),

                  // ── Director + Year ─────────────────────────────
                  Text(
                    '${movie.director}  •  ${movie.releaseYear}',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: AppConstants.paddingSM),

                  // ── Genre + Content Type Chips ──────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        label: movie.genre,
                        color: _genreColor(movie.genre),
                      ),
                      _InfoChip(
                        label: movie.contentType,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingLG),

                  // ── Rating ──────────────────────────────────────
                  Text('Rating', style: AppTextStyles.title),
                  const SizedBox(height: AppConstants.paddingSM),
                  RatingWidget.display(
                    rating: movie.rating,
                    itemSize: 32,
                  ),
                  const SizedBox(height: AppConstants.paddingLG),

                  // ── Review ──────────────────────────────────────
                  Text('Review', style: AppTextStyles.title),
                  const SizedBox(height: AppConstants.paddingSM),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingMD),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD),
                    ),
                    child: Text(movie.review, style: AppTextStyles.body),
                  ),
                  const SizedBox(height: AppConstants.paddingLG),

                  // ── Date Added ──────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 6),
                      Text(
                        'Added on ${_formatDate(movie.dateAdded)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      '',
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
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  static Color _genreColor(String genre) {
    switch (genre) {
      case 'Action':
        return AppColors.tagAction;
      case 'Drama':
        return AppColors.tagDrama;
      case 'Comedy':
        return AppColors.tagComedy;
      case 'Thriller':
        return AppColors.tagThriller;
      case 'Horror':
        return AppColors.tagHorror;
      case 'Sci-Fi':
        return AppColors.tagSciFi;
      default:
        return AppColors.tagDefault;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Private helper widgets
// ═════════════════════════════════════════════════════════════════════════════

class _PosterSection extends StatelessWidget {
  const _PosterSection({required this.posterUrl});
  final String? posterUrl;

  @override
  Widget build(BuildContext context) {
    if (posterUrl != null && posterUrl!.isNotEmpty) {
      return SizedBox(
        height: 260,
        width: double.infinity,
        child: Image.network(
          posterUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: 200,
      color: AppColors.secondary,
      child: Center(
        child: Icon(Icons.movie_outlined,
            size: 64, color: AppColors.accent.withValues(alpha: 0.6)),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: AppTextStyles.caption.copyWith(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
    );
  }
}
