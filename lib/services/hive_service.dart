import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../models/movie_model.dart';

/// Manages all Hive database operations for FilmDiary.
///
/// This service encapsulates every CRUD interaction with the local
/// Hive box so that screens never touch the database directly.
///
/// Usage:
/// ```dart
/// final hive = HiveService();
/// await hive.addMovie(movie);
/// final all = hive.getAllMovies();
/// ```
///
/// The singleton pattern ensures only one instance exists app-wide.
class HiveService {
  // ─── Singleton ─────────────────────────────────────────────────────────

  HiveService._internal();
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;

  // ─── UUID Generator ────────────────────────────────────────────────────

  static const _uuid = Uuid();

  // ─── Box Accessor ──────────────────────────────────────────────────────

  /// Returns the opened Hive box that stores [MovieModel] entries.
  /// The box is opened once in [main()] before runApp() is called.
  Box<MovieModel> get _box => Hive.box<MovieModel>(AppConstants.moviesBoxName);

  // ─── Initialization ────────────────────────────────────────────────────

  /// Registers the [MovieModelAdapter] and opens the movies box.
  /// Must be called once during app startup (in main.dart).
  static Future<void> init() async {
    Hive.registerAdapter(MovieModelAdapter());
    await Hive.openBox<MovieModel>(AppConstants.moviesBoxName);
  }

  // ─── CREATE ────────────────────────────────────────────────────────────

  /// Adds a new movie to the database.
  ///
  /// Accepts all user input fields and auto-generates the UUID and date.
  Future<void> addMovie({
    required String title,
    required String director,
    required int releaseYear,
    required String genre,
    required String contentType,
    required double rating,
    required String review,
    String? posterUrl,
  }) async {
    final movie = MovieModel(
      id: _uuid.v4(),
      title: title,
      director: director,
      releaseYear: releaseYear,
      genre: genre,
      contentType: contentType,
      rating: rating,
      review: review,
      dateAdded: DateTime.now(),
      posterUrl: posterUrl,
    );

    // Use the UUID as the key so we can look up by id in O(1)
    await _box.put(movie.id, movie);
  }

  // ─── READ ──────────────────────────────────────────────────────────────

  /// Returns all movies, most recently added first.
  List<MovieModel> getAllMovies() {
    final movies = _box.values.toList();
    movies.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return movies;
  }

  /// Total number of saved movies.
  int get movieCount => _box.length;

  /// Returns a single movie by its [id], or null if not found.
  MovieModel? getMovieById(String id) {
    return _box.get(id);
  }

  // ─── UPDATE ────────────────────────────────────────────────────────────

  /// Replaces an existing movie entry with the same ID.
  Future<void> updateMovie(MovieModel updatedMovie) async {
    await _box.put(updatedMovie.id, updatedMovie);
  }

  // ─── DELETE ────────────────────────────────────────────────────────────

  /// Removes the movie with the given [id] from the database.
  Future<void> deleteMovie(String id) async {
    await _box.delete(id);
  }

  /// Removes all movies from the database.
  Future<void> deleteAllMovies() async {
    await _box.clear();
  }
}
