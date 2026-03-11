/// Global constants used throughout the FilmDiary application.
///
/// Centralizing these magic values prevents duplication and makes
/// global changes (e.g. changing padding scale) trivially easy.
abstract class AppConstants {
  // ─── App Info ──────────────────────────────────────────────────────────
  static const String appName = 'FilmDiary';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your Personal Cinema Journal';

  // ─── Hive Box Names ────────────────────────────────────────────────────
  /// The Hive box that stores all MovieModel entries (opened in Phase 2)
  static const String moviesBoxName = 'movies_box';

  // ─── Splash ────────────────────────────────────────────────────────────
  /// How many seconds the splash screen stays visible before navigating away
  static const int splashDurationSeconds = 2;

  // ─── Spacing ───────────────────────────────────────────────────────────
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // ─── Border Radius ─────────────────────────────────────────────────────
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // ─── Movie Genres ──────────────────────────────────────────────────────
  static const List<String> movieGenres = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Thriller',
    'Sci-Fi',
    'Romance',
    'Animation',
    'Documentary',
    'Fantasy',
    'Mystery',
    'Crime',
  ];

  // ─── Content Types ─────────────────────────────────────────────────────
  static const List<String> contentTypes = [
    'Movie',
    'Web Series',
    'Short Film',
    'Documentary',
    'Mini Series',
  ];

  // ─── Rating Labels ─────────────────────────────────────────────────────
  /// Human-readable labels for star rating values (1–5).
  /// Keys are integers — use `rating.round()` to look up the label.
  static const Map<int, String> ratingLabels = {
    1: 'Terrible',
    2: 'Bad',
    3: 'Average',
    4: 'Good',
    5: 'Excellent',
  };
}
