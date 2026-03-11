import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Centralized text style definitions for FilmDiary.
///
/// All text in the application should reference these styles instead of using
/// raw TextStyle() calls in widgets. This ensures typographic consistency and
/// makes font/size changes trivially easy in the future.
///
/// Font: Poppins — modern, geometric sans-serif that works beautifully on mobile.
abstract class AppTextStyles {
  // ─── Display / Hero ────────────────────────────────────────────────────
  /// Large screen headings (e.g. splash screen title)
  static final TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Section headings (e.g. "My Diary", "Top Rated")
  static final TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    letterSpacing: -0.3,
  );

  // ─── Title ─────────────────────────────────────────────────────────────
  /// Card movie title
  static final TextStyle title = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    height: 1.3,
  );

  /// Smaller title (e.g. dialog headers)
  static final TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  // ─── Subtitle ──────────────────────────────────────────────────────────
  /// Secondary label beneath a title (e.g. director name)
  static final TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
  );

  // ─── Body ──────────────────────────────────────────────────────────────
  /// Main readable body text
  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
    height: 1.6,
  );

  /// Smaller body / secondary info
  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
    height: 1.5,
  );

  // ─── Caption / Label ───────────────────────────────────────────────────
  /// Tiny metadata label (dates, tags)
  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.2,
  );

  /// uppercased micro-label (e.g. genre badge text)
  static final TextStyle label = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  // ─── Button ────────────────────────────────────────────────────────────
  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // ─── AppBar ────────────────────────────────────────────────────────────
  static final TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.4,
  );
}
