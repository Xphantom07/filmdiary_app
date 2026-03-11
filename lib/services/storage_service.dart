import '../models/movie_model.dart';

/// Manages all data persistence for FilmDiary.
///
/// Architecture notes
/// ──────────────────
/// Phase 1: In-memory implementation — data is lost when the app restarts.
///          This gives us a fully functional interface to code against
///          while keeping the codebase simple for the foundation phase.
///
/// Phase 2: Replace the in-memory list with a real Hive box. All callers
///          (HomeScreen, AddMovieScreen, etc.) use this service and will
///          automatically benefit from persistence without any changes.
///
/// The service is a singleton — access it anywhere with `StorageService()`.
class StorageService {
  // ─── Singleton Setup ───────────────────────────────────────────────────

  StorageService._internal();

  static final StorageService _instance = StorageService._internal();

  /// Returns the single shared instance of [StorageService].
  factory StorageService() => _instance;

  // ─── In-Memory Store (Phase 1) ─────────────────────────────────────────

  final List<MovieModel> _movies = [];

  // ─── Public API ────────────────────────────────────────────────────────

  /// Returns an unmodifiable view of all saved movie entries.
  List<MovieModel> getAllMovies() => List.unmodifiable(_movies);

  /// Returns the total number of saved movies.
  int get movieCount => _movies.length;

  /// Saves a new [MovieModel] to the store.
  void addMovie(MovieModel movie) {
    _movies.add(movie);
  }

  /// Replaces the movie whose [MovieModel.id] matches [updatedMovie.id].
  ///
  /// Does nothing if no matching movie is found.
  void updateMovie(MovieModel updatedMovie) {
    final index = _movies.indexWhere((m) => m.id == updatedMovie.id);
    if (index != -1) {
      _movies[index] = updatedMovie;
    }
  }

  /// Removes the movie with the given [id].
  ///
  /// Does nothing if no matching movie is found.
  void deleteMovie(String id) {
    _movies.removeWhere((m) => m.id == id);
  }

  /// Returns the movie with the given [id], or null if not found.
  MovieModel? getMovieById(String id) {
    try {
      return _movies.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns movies filtered by [genre].
  List<MovieModel> getMoviesByGenre(String genre) {
    return _movies.where((m) => m.genre == genre).toList();
  }

  /// Returns movies whose titles contain [query] (case-insensitive).
  List<MovieModel> searchMovies(String query) {
    final lower = query.toLowerCase();
    return _movies
        .where((m) =>
            m.title.toLowerCase().contains(lower) ||
            m.director.toLowerCase().contains(lower))
        .toList();
  }

  /// Returns movies sorted by user rating (highest first).
  List<MovieModel> getTopRated() {
    final sorted = List<MovieModel>.from(_movies)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }
}
