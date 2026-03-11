import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../services/hive_service.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/rating_widget.dart';

/// Screen that lets the user add a new movie or web-series entry to their diary.
///
/// Contains a validated form with fields for title, director, year, genre,
/// content type, poster URL, rating, and a free-text review.
///
/// On successful save, calls [HiveService.addMovie] and pops back with `true`
/// so the caller (HomeScreen) knows to refresh its list.
class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // ─── Form State ────────────────────────────────────────────────────────

  final _formKey = GlobalKey<FormState>();
  final _hive = HiveService();

  final _titleCtrl = TextEditingController();
  final _directorCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _posterCtrl = TextEditingController();
  final _reviewCtrl = TextEditingController();

  double _rating = 0.0;
  String _selectedGenre = AppConstants.movieGenres.first;
  String _selectedType = AppConstants.contentTypes.first;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _directorCtrl.dispose();
    _yearCtrl.dispose();
    _posterCtrl.dispose();
    _reviewCtrl.dispose();
    super.dispose();
  }

  // ─── Save Handler ──────────────────────────────────────────────────────

  Future<void> _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    if (_rating == 0.0) {
      _showSnackBar('Please give a star rating before saving.');
      return;
    }

    setState(() => _isSaving = true);

    await _hive.addMovie(
      title: _titleCtrl.text.trim(),
      director: _directorCtrl.text.trim(),
      releaseYear: int.parse(_yearCtrl.text.trim()),
      genre: _selectedGenre,
      contentType: _selectedType,
      rating: _rating,
      review: _reviewCtrl.text.trim(),
      posterUrl:
          _posterCtrl.text.trim().isEmpty ? null : _posterCtrl.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop(true); // signal HomeScreen to reload
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        margin: const EdgeInsets.all(AppConstants.paddingMD),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Movie',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Section Title ──────────────────────────────────────
              Text('Movie Details', style: AppTextStyles.headline2),
              const SizedBox(height: AppConstants.paddingMD),

              // ── Title ─────────────────────────────────────────────
              _buildTextField(
                controller: _titleCtrl,
                label: 'Movie Title',
                hint: 'e.g. Inception',
                icon: Icons.movie_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: AppConstants.paddingMD),

              // ── Director ──────────────────────────────────────────
              _buildTextField(
                controller: _directorCtrl,
                label: 'Director',
                hint: 'e.g. Christopher Nolan',
                icon: Icons.person_outline_rounded,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Director is required'
                    : null,
              ),
              const SizedBox(height: AppConstants.paddingMD),

              // ── Year + Genre Row ──────────────────────────────────
              Row(
                children: [
                  // Year
                  Expanded(
                    child: _buildTextField(
                      controller: _yearCtrl,
                      label: 'Year',
                      hint: 'e.g. 2010',
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final year = int.tryParse(v.trim());
                        if (year == null || year < 1888 || year > 2100) {
                          return 'Invalid year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMD),
                  // Genre dropdown
                  Expanded(child: _buildGenreDropdown()),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMD),

              // ── Content Type ──────────────────────────────────────
              _buildContentTypeDropdown(),
              const SizedBox(height: AppConstants.paddingMD),

              // ── Poster URL ────────────────────────────────────────
              _buildTextField(
                controller: _posterCtrl,
                label: 'Poster URL (optional)',
                hint: 'https://image.tmdb.org/...',
                icon: Icons.image_outlined,
              ),
              const SizedBox(height: AppConstants.paddingLG),

              // ── Rating ────────────────────────────────────────────
              Text('Your Rating', style: AppTextStyles.title),
              const SizedBox(height: AppConstants.paddingSM),
              RatingWidget(
                rating: _rating,
                itemSize: 40,
                onRatingChanged: (value) => setState(() => _rating = value),
              ),
              const SizedBox(height: AppConstants.paddingLG),

              // ── Review ────────────────────────────────────────────
              _buildTextField(
                controller: _reviewCtrl,
                label: 'Your Review',
                hint: 'Write your thoughts about this movie...',
                icon: Icons.rate_review_outlined,
                maxLines: 5,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Review is required' : null,
              ),
              const SizedBox(height: AppConstants.paddingXL),

              // ── Save Button ───────────────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveMovie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD),
                    ),
                    elevation: 3,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text('Save Movie',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                ),
              ),
              const SizedBox(height: AppConstants.paddingLG),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Reusable Form Helpers ─────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        labelStyle: AppTextStyles.subtitle,
      ),
    );
  }

  Widget _buildGenreDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGenre,
      decoration: InputDecoration(
        labelText: 'Genre',
        prefixIcon: const Icon(Icons.category_outlined,
            color: AppColors.primary, size: 20),
        labelStyle: AppTextStyles.subtitle,
      ),
      items: AppConstants.movieGenres
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _selectedGenre = value);
      },
    );
  }

  Widget _buildContentTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      decoration: InputDecoration(
        labelText: 'Content Type',
        prefixIcon: const Icon(Icons.videocam_outlined,
            color: AppColors.primary, size: 20),
        labelStyle: AppTextStyles.subtitle,
      ),
      items: AppConstants.contentTypes
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _selectedType = value);
      },
    );
  }
}
