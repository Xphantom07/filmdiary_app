import 'package:flutter/material.dart';

/// Centralized color palette for FilmDiary.
///
/// Every color used in the application is defined here.
/// Never use raw Color literals in widgets — always reference this file.
abstract class AppColors {
  // ─── Primary Brand Colors ──────────────────────────────────────────────
  /// Deep cinematic navy — the main brand identity color
  static const Color primary = Color(0xFF1A1A2E);

  /// Rich dark blue — used for secondary surfaces and appbars in dark mode
  static const Color secondary = Color(0xFF16213E);

  /// Warm golden amber — accent color for highlights, FAB, and stars
  static const Color accent = Color(0xFFE8A045);

  // ─── Background Colors ─────────────────────────────────────────────────
  /// Light mode scaffold/page background
  static const Color backgroundLight = Color(0xFFF4F6F9);

  /// Dark mode scaffold/page background
  static const Color backgroundDark = Color(0xFF0F0F1A);

  // ─── Surface / Card Colors ─────────────────────────────────────────────
  /// Light mode card and dialog surface
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Dark mode card and dialog surface
  static const Color cardDark = Color(0xFF1E1E30);

  // ─── Text Colors ───────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF1F1F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // ─── Utility ───────────────────────────────────────────────────────────
  static const Color starRating = Color(0xFFFFB800);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // ─── Genre Tag Pill Colors ─────────────────────────────────────────────
  static const Color tagAction = Color(0xFFFF6B6B);
  static const Color tagDrama = Color(0xFF4ECDC4);
  static const Color tagComedy = Color(0xFFFFC107);
  static const Color tagThriller = Color(0xFF6C5CE7);
  static const Color tagHorror = Color(0xFF2D3436);
  static const Color tagSciFi = Color(0xFF0984E3);
  static const Color tagDefault = Color(0xFF636E72);
}
