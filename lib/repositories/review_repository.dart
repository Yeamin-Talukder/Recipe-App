import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/review.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ReviewRepository {
  final FirestoreService _db;
  final AuthService _auth;

  static const String _recipesCollection = 'recipes_v4';
  static const String _reviewsSubcollection = 'reviews';

  ReviewRepository({
    required AuthService authService,
    FirestoreService? firestoreService,
  })  : _auth = authService,
        _db = firestoreService ?? FirestoreService();

  // ─── Stream ────────────────────────────────────────────────────────────────

  /// Real-time stream of all reviews for a recipe (newest first).
  Stream<List<Review>> streamReviews(String recipeId) {
    return _db.streamSubcollection<Review>(
      parentCollection: _recipesCollection,
      parentId: recipeId,
      subcollection: _reviewsSubcollection,
      builder: (id, data) => Review.fromFirestore(id, data),
      orderByField: 'createdAt',
      descending: true,
    );
  }

  // ─── Write ─────────────────────────────────────────────────────────────────

  /// Add or update the current user's review for [recipeId].
  /// Atomically recalculates the recipe's aggregate rating & review count.
  Future<void> addOrUpdateReview({
    required String recipeId,
    required double rating,
    required String comment,
    Review? existingReview,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Must be signed in to review');

    final userName = user.displayName ?? 'Anonymous';
    final userPhoto = user.photoURL;
    final userId = user.uid;

    final reviewRef = _db.collRef(
      '$_recipesCollection/$recipeId/$_reviewsSubcollection',
    ).doc(userId);

    final recipeRef = _db.docRef('$_recipesCollection/$recipeId');

    await _db.runTransaction((txn) async {
      final recipeSnap = await txn.get(recipeRef);
      final data = recipeSnap.data() as Map<String, dynamic>? ?? {};

      double currentRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
      int currentCount = (data['reviews'] as int?) ?? 0;

      double newRating;
      int newCount;

      if (existingReview != null) {
        // Editing: replace old rating contribution
        final sumWithout = currentRating * currentCount - existingReview.rating;
        newCount = currentCount; // count stays the same
        newRating = currentCount > 0
            ? (sumWithout + rating) / newCount
            : rating;
      } else {
        // New review
        newCount = currentCount + 1;
        newRating = (currentRating * currentCount + rating) / newCount;
      }

      // Clamp to valid range
      newRating = newRating.clamp(0.0, 5.0);

      txn.set(
        reviewRef,
        {
          'userId': userId,
          'userName': userName,
          'userPhoto': userPhoto,
          'rating': rating,
          'comment': comment,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      txn.update(recipeRef, {
        'rating': double.parse(newRating.toStringAsFixed(1)),
        'reviews': newCount,
      });
    });
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  /// Delete the current user's review and recalculate aggregate atomically.
  Future<void> deleteReview({
    required String recipeId,
    required Review review,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Must be signed in');

    final reviewRef = _db.collRef(
      '$_recipesCollection/$recipeId/$_reviewsSubcollection',
    ).doc(user.uid);

    final recipeRef = _db.docRef('$_recipesCollection/$recipeId');

    await _db.runTransaction((txn) async {
      final recipeSnap = await txn.get(recipeRef);
      final data = recipeSnap.data() as Map<String, dynamic>? ?? {};

      double currentRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
      int currentCount = (data['reviews'] as int?) ?? 0;

      int newCount = (currentCount - 1).clamp(0, 999999);
      double newRating = 0.0;

      if (newCount > 0) {
        final sumWithout = currentRating * currentCount - review.rating;
        newRating = (sumWithout / newCount).clamp(0.0, 5.0);
      }

      txn.delete(reviewRef);
      txn.update(recipeRef, {
        'rating': double.parse(newRating.toStringAsFixed(1)),
        'reviews': newCount,
      });
    });

    debugPrint('Review deleted for recipe $recipeId');
  }
}
