import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../screens/add_movie/add_movie_screen.dart';
import '../screens/edit_movie/edit_movie_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';
import '../screens/splash/splash_screen.dart';

/// Defines all named routes for FilmDiary.
///
/// Using named routes keeps navigation logic out of individual widgets
/// and makes deep-linking and route guards easy to add in Phase 2.
abstract class AppRoutes {
  // ─── Route Name Constants ──────────────────────────────────────────────
  static const String splash = '/';
  static const String home = '/home';

  // Phase 2 routes — defined here so the rest of the codebase can reference
  // them as constants before their screens are implemented.
  static const String addMovie = '/add-movie';
  static const String editMovie = '/edit-movie';
  static const String movieDetail = '/movie-detail';

  // ─── Route Generator ──────────────────────────────────────────────────

  /// Called by [MaterialApp.onGenerateRoute] for every navigation event.
  ///
  /// Returns a [MaterialPageRoute] for known routes, or a 404-style fallback
  /// for unknown routes so the app never crashes on navigation errors.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Splash ──────────────────────────────────────────────────────
      case splash:
        return _buildRoute(const SplashScreen(), settings);

      // ── Home ────────────────────────────────────────────────────────
      case home:
        return _buildRoute(const HomeScreen(), settings);

      // ── Add Movie ─────────────────────────────────────────────────────
      case addMovie:
        return _buildRoute(const AddMovieScreen(), settings);

      // ── Edit Movie ────────────────────────────────────────────────────
      case editMovie:
        final movie = settings.arguments as MovieModel;
        return _buildRoute(EditMovieScreen(movie: movie), settings);

      // ── Movie Detail ──────────────────────────────────────────────────
      case movieDetail:
        final movie = settings.arguments as MovieModel;
        return _buildRoute(MovieDetailScreen(movie: movie), settings);

      // ── Unknown Route Fallback ──────────────────────────────────────
      default:
        return _buildRoute(
          _ErrorScreen(routeName: settings.name ?? 'unknown'),
          settings,
        );
    }
  }

  // ─── Private Helpers ──────────────────────────────────────────────────

  /// Creates a [MaterialPageRoute] with a smooth fade transition.
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => page,
    );
  }
}

// ─── Internal Fallback Screen ───────────────────────────────────────────── /// Shown when navigating to an undefined route — prevents white screen crashes.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text(
          'No route defined for "$routeName"',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
