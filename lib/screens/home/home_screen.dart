import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../models/movie_model.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/movie_card.dart';

/// The main screen of FilmDiary — the user's personal movie diary.
///
/// Phase 1: Displays the empty-state UI with a prompt to add the first movie.
/// Phase 2: Will show a live list of [MovieCard]s from [StorageService],
///          a search bar, and genre filter chips.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ─── State ────────────────────────────────────────────────────────────
  final HiveService _hive = HiveService();

  /// The movie list — refreshed every time the screen is revisited.
  List<MovieModel> _movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  /// Reads the current movie list from [HiveService] and updates state.
  void _loadMovies() {
    setState(() {
      _movies = _hive.getAllMovies();
    });
  }

  // ─── Handlers ─────────────────────────────────────────────────────────

  /// FAB action — navigates to Add Movie screen.
  void _onAddMovieTapped() {
    Navigator.of(context).pushNamed(AppRoutes.addMovie).then((added) {
      if (added == true) _loadMovies();
    });
  }

  /// Card tap — navigates to Movie Detail screen.
  void _onMovieTapped(MovieModel movie) {
    Navigator.of(context)
        .pushNamed(AppRoutes.movieDetail, arguments: movie)
        .then((changed) {
      if (changed == true) _loadMovies();
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasMovies = _movies.isNotEmpty;

    return Scaffold(
      // ── AppBar ───────────────────────────────────────────────────────
      appBar: CustomAppBar(
        title: AppConstants.appName,
        subtitle: hasMovies
            ? '${_movies.length} ${_movies.length == 1 ? 'movie' : 'movies'} logged'
            : AppConstants.appTagline,
        actions: [
          const SizedBox(width: 4),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────────────
      body: hasMovies
          ? _MovieListView(
              movies: _movies,
              onMovieTap: _onMovieTapped,
            )
          : const _EmptyState(),

      // ── Floating Action Button ────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMovieTapped,
        tooltip: 'Add movie',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}

// ─── Sub-Widgets ──────────────────────────────────────────────────────────

/// Shown when the user has not added any movies yet.
///
/// Designed to encourage the first action rather than feel like an error state.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.movie_creation_outlined,
                size: 56,
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Your diary is empty',
              style: AppTextStyles.headline2.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              'Tap the  +  button below to log\nyour first watched movie or series.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Decorative divider row
            Row(
              children: [
                Expanded(
                  child: Divider(color: AppColors.divider, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMD,
                  ),
                  child: Text(
                    'Start your cinema journal',
                    style: AppTextStyles.caption,
                  ),
                ),
                Expanded(
                  child: Divider(color: AppColors.divider, thickness: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Scrollable list of [MovieCard] widgets.
///
/// Separated into its own widget for clarity — [HomeScreen._HomeScreenState]
/// stays focused purely on state management.
class _MovieListView extends StatelessWidget {
  const _MovieListView({
    required this.movies,
    required this.onMovieTap,
  });

  final List<MovieModel> movies;
  final void Function(MovieModel) onMovieTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Extra top/bottom padding so cards don't bump against edges
      padding: const EdgeInsets.only(
        top: AppConstants.paddingMD,
        bottom: 100, // room above the FAB
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          movie: movie,
          onTap: () => onMovieTap(movie),
          // Long-press context menu will be added in Phase 2
        );
      },
    );
  }
}
