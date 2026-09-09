import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/firestore_service.dart';
import '../utils/mock_data.dart';

class RecipeRepository {
  final FirestoreService _firestoreService;
  final String collectionName = 'recipes_v4';

  RecipeRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

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

  // Helper method to seed initial mock data during development
  Future<void> seedMockData() async {
    try {
      final items = mockRecipes.map((r) => r.toFirestore()).toList();
      await _firestoreService.batchSet(
        collectionPath: collectionName,
        items: items,
        idGenerator: (item) => mockRecipes
            .firstWhere((r) => r.name == item['name'], orElse: () => mockRecipes.first)
            .id,
      );
      debugPrint("Successfully seeded mock data to Firestore");
    } catch (e) {
      debugPrint("Error seeding data: $e");
    }
  }
}
