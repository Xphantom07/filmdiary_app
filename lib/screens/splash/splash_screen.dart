import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../routes/app_routes.dart';

/// The first screen users see when the app launches.
///
/// Displays the FilmDiary brand mark with a fade-and-scale entrance animation,
/// then automatically navigates to [HomeScreen] after [AppConstants.splashDurationSeconds].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ─── Animation ──────────────────────────────────────────────────────────
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Total intro animation duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Logo/text fades in from transparent to opaque
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // Logo gently scales up from 80% to 100%
    _scaleAnim = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    // Start animation immediately
    _controller.forward();

    // Schedule navigation to Home after the splash duration
    _scheduleNavigation();
  }

  /// Waits for [AppConstants.splashDurationSeconds] then navigates away.
  /// The [mounted] check prevents setState/navigation on a disposed widget.
  Future<void> _scheduleNavigation() async {
    await Future.delayed(
      Duration(seconds: AppConstants.splashDurationSeconds),
    );
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Deep cinematic navy background matching the brand
      backgroundColor: AppColors.primary,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Film Reel Icon ─────────────────────────────────
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.movie_filter_rounded,
                        size: 48,
                        color: AppColors.accent,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── App Name ───────────────────────────────────────
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.headline1.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Tagline ────────────────────────────────────────
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.subtitle.copyWith(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // ── Loading Indicator ──────────────────────────────
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accent.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
