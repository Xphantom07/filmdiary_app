import 'package:hive/hive.dart';

part 'movie_model.g.dart';

/// Represents a single movie or web-series entry in the user's FilmDiary.
///
/// Annotated with `@HiveType` / `@HiveField` so the build_runner can
/// auto-generate the [MovieModelAdapter] used to serialize this object
/// into the local Hive database.
///
/// Generate the adapter with:
///   flutter pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 0)
class MovieModel extends HiveObject {
  // ─── Fields ────────────────────────────────────────────────────────────

  /// Unique identifier (UUID v4)
  @HiveField(0)
  final String id;

  /// Title of the movie or web series
  @HiveField(1)
  final String title;

  /// Director's full name
  @HiveField(2)
  final String director;

  /// Original release year (e.g. 2023)
  @HiveField(3)
  final int releaseYear;

  /// Primary genre (e.g. "Action", "Drama")
  @HiveField(4)
  final String genre;

  /// Content category — "Movie", "Web Series", "Short Film", etc.
  @HiveField(5)
  final String contentType;

  /// User's personal star rating out of 5 (supports half-stars)
  @HiveField(6)
  final double rating;

  /// User's personal notes or review text
  @HiveField(7)
  final String review;

  /// Timestamp when this entry was added to the diary
  @HiveField(8)
  final DateTime dateAdded;

  /// Optional poster image URL
  @HiveField(9)
  final String? posterUrl;

  // ─── Constructor ───────────────────────────────────────────────────────

  MovieModel({
    required this.id,
    required this.title,
    required this.director,
    required this.releaseYear,
    required this.genre,
    required this.contentType,
    required this.rating,
    required this.review,
    required this.dateAdded,
    this.posterUrl,
  });

  // ─── CopyWith ──────────────────────────────────────────────────────────

  /// Returns a modified copy of this instance — used when editing a movie.
  MovieModel copyWith({
    String? title,
    String? director,
    int? releaseYear,
    String? genre,
    String? contentType,
    double? rating,
    String? review,
    String? posterUrl,
  }) {
    return MovieModel(
      id: id,
      title: title ?? this.title,
      director: director ?? this.director,
      releaseYear: releaseYear ?? this.releaseYear,
      genre: genre ?? this.genre,
      contentType: contentType ?? this.contentType,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      dateAdded: dateAdded,
      posterUrl: posterUrl ?? this.posterUrl,
    );
  }

  // ─── Equality ──────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MovieModel(id: $id, title: $title, rating: $rating)';
}
