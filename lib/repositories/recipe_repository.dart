import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';
import '../utils/demo_reviews.dart';

class RecipeRepository {
  final FirestoreService _firestoreService;
  final String collectionName = 'recipes_v4';

  RecipeRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // ── One-shot fetch ─────────────────────────────────────────────────────────

  Future<List<Recipe>> getRecipes() async {
    try {
      final recipes = await _firestoreService.getCollection<Recipe>(
        collectionPath: collectionName,
        builder: (id, data) => Recipe.fromFirestore(id, data),
      );

      if (recipes.length < mockRecipes.length) {
        // Fallback to mock data & attempt to seed Firestore for development
        await seedMockData();
        // Return the full mock data list immediately so the UI updates
        return mockRecipes;
      }
      return recipes;
    } catch (e) {
      debugPrint("Error fetching recipes from Firestore: $e");
      // Fallback to mock data for local development if network/Firebase fails
      return mockRecipes;
    }
  }

  // ── Real-time stream ────────────────────────────────────────────────────────

  /// Streams the recipes collection so cards update live when
  /// reviews change the aggregate rating/reviews fields.
  Stream<List<Recipe>> streamRecipes() {
    return _firestoreService.streamCollection<Recipe>(
      collectionPath: collectionName,
      builder: (id, data) => Recipe.fromFirestore(id, data),
    );
  }

  // ── Seed mock data ─────────────────────────────────────────────────────────

  /// Seeds recipes AND demo reviews to Firestore on first run.
  Future<void> seedMockData() async {
    try {
      // 1. Write recipe documents
      final items = mockRecipes.map((r) => r.toFirestore()).toList();
      await _firestoreService.batchSet(
        collectionPath: collectionName,
        items: items,
        idGenerator: (item) => mockRecipes
            .firstWhere((r) => r.name == item['name'],
                orElse: () => mockRecipes.first)
            .id,
      );
      debugPrint("Successfully seeded mock recipe data to Firestore");

      // 2. Seed demo reviews for every recipe
      await seedDemoReviews();
    } catch (e) {
      debugPrint("Error seeding data: $e");
    }
  }

  /// Pushes demo reviews into each recipe's reviews subcollection and
  /// atomically updates the recipe document's [rating] and [reviews] fields.
  Future<void> seedDemoReviews() async {
    try {
      final db = FirebaseFirestore.instance;

      for (final entry in demoReviews.entries) {
        final recipeId = entry.key;
        final reviews = entry.value;
        if (reviews.isEmpty) continue;

        final recipeRef = db.collection(collectionName).doc(recipeId);

        // Check if demo reviews already seeded (avoid duplicate writes)
        final firstUserId = reviews.first['userId'] as String;
        final existingDoc = await recipeRef
            .collection('reviews')
            .doc(firstUserId)
            .get();
        if (existingDoc.exists) {
          debugPrint('Demo reviews already seeded for recipe $recipeId, skipping.');
          continue;
        }

        // Compute aggregate from the demo reviews
        final count = reviews.length;
        final avgRating = reviews.fold<double>(
                0.0, (sum, r) => sum + (r['rating'] as num).toDouble()) /
            count;
        final roundedRating =
            double.parse(avgRating.toStringAsFixed(1));

        // Batch-write all review sub-docs + update recipe aggregate
        final batch = db.batch();

        for (final reviewMap in reviews) {
          final userId = reviewMap['userId'] as String;
          final reviewRef =
              recipeRef.collection('reviews').doc(userId);
          batch.set(reviewRef, reviewMap, SetOptions(merge: true));
        }

        batch.update(recipeRef, {
          'rating': roundedRating,
          'reviews': count,
        });

        await batch.commit();
        debugPrint(
            'Seeded ${reviews.length} demo reviews for recipe $recipeId (avg $roundedRating)');
      }

      debugPrint('Demo review seeding complete.');
    } catch (e) {
      debugPrint('Error seeding demo reviews: $e');
    }
  }
}

