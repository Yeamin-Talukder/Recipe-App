import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/review.dart';
import '../repositories/review_repository.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _repository;

  List<Review> _reviews = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  StreamSubscription<List<Review>>? _sub;
  String? _currentRecipeId;

  ReviewProvider({required ReviewRepository repository})
      : _repository = repository;

  // ─── Getters ───────────────────────────────────────────────────────────────
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  /// Returns the signed-in user's own review (null if none).
  Review? myReview(String userId) =>
      _reviews.where((r) => r.userId == userId).firstOrNull;

  /// Rating breakdown: key = star (1–5), value = count
  Map<int, int> get ratingBreakdown {
    final map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in _reviews) {
      final star = r.rating.round().clamp(1, 5);
      map[star] = (map[star] ?? 0) + 1;
    }
    return map;
  }

  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    final sum = _reviews.fold(0.0, (acc, r) => acc + r.rating);
    return sum / _reviews.length;
  }

  // ─── Load ──────────────────────────────────────────────────────────────────

  /// Subscribe to real-time updates for [recipeId].
  void loadReviews(String recipeId) {
    if (_currentRecipeId == recipeId) return; // already listening
    _currentRecipeId = recipeId;

    _isLoading = true;
    _error = null;
    notifyListeners();

    _sub?.cancel();
    _sub = _repository.streamReviews(recipeId).listen(
      (data) {
        _reviews = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load reviews';
        _isLoading = false;
        debugPrint('ReviewProvider stream error: $e');
        notifyListeners();
      },
    );
  }

  void resetForNewRecipe() {
    _sub?.cancel();
    _sub = null;
    _currentRecipeId = null;
    _reviews = [];
    _isLoading = false;
    _error = null;
  }

  // ─── Submit ────────────────────────────────────────────────────────────────

  Future<bool> submitReview({
    required String recipeId,
    required double rating,
    required String comment,
    required String userId,
    Review? existingReview,
  }) async {
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addOrUpdateReview(
        recipeId: recipeId,
        rating: rating,
        comment: comment,
        existingReview: existingReview,
      );
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to submit review. Please try again.';
      _isSubmitting = false;
      debugPrint('ReviewProvider submitReview error: $e');
      notifyListeners();
      return false;
    }
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  Future<bool> deleteReview({
    required String recipeId,
    required Review review,
  }) async {
    // Optimistic UI
    final prev = List<Review>.from(_reviews);
    _reviews.removeWhere((r) => r.id == review.id);
    notifyListeners();

    try {
      await _repository.deleteReview(recipeId: recipeId, review: review);
      return true;
    } catch (e) {
      _reviews = prev; // rollback
      _error = 'Failed to delete review.';
      debugPrint('ReviewProvider deleteReview error: $e');
      notifyListeners();
      return false;
    }
  }

  // ─── Dispose ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
