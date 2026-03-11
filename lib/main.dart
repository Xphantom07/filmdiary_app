import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'services/hive_service.dart';

/// ──────────────────────────────────────────────────────────────────────────
/// FilmDiary — Entry Point
/// ──────────────────────────────────────────────────────────────────────────
///
/// Performs all startup work before the first frame is drawn:
///  1. Ensures the Flutter engine is fully initialized.
///  2. Initializes Hive (local database) with the device's documents directory.
///  3. Locks the device to portrait orientation for a consistent layout.
///
/// Phase 2 will register Hive TypeAdapters here (e.g. MovieModelAdapter)
/// and open the movies box before runApp() is called.
Future<void> main() async {
  // Must be called before any async work in main()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive — uses path_provider under the hood to find storage path
  await Hive.initFlutter();

  // Register Hive adapters and open storage boxes
  await HiveService.init();

  // Lock orientation to portrait so the layout never breaks on rotation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const FilmDiaryApp());
}

/// Root widget of the FilmDiary application.
///
/// Configures:
///  - Material 3 theming (light + dark, switches with device setting)
///  - Named route navigation (all routes in [AppRoutes])
///  - Debug banner disabled for a clean UI during development
class FilmDiaryApp extends StatelessWidget {
  const FilmDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── App metadata ─────────────────────────────────────────────────
      title: 'FilmDiary',
      debugShowCheckedModeBanner: false,

      // ── Theme — defined in core/theme/app_theme.dart ─────────────────
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follows the device's light/dark setting

      // ── Navigation — all routes defined in routes/app_routes.dart ─────
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
