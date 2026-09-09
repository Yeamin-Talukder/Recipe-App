import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final String collectionName = 'users';
  final String favoritesSubcollection = 'favorites';

  UserRepository({
    required AuthService authService,
    FirestoreService? firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService ?? FirestoreService();

  Future<List<String>> getFavorites() async {
    final user = _authService.currentUser;
    if (user == null) return [];

    try {
      final favDocs = await _firestoreService.getSubcollection<String>(
        parentCollection: collectionName,
        parentId: user.uid,
        subcollection: favoritesSubcollection,
        builder: (id, data) => id,
      );
      return favDocs;
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
    return [];
  }

  Future<void> addFavorite(String recipeId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not authenticated");

    try {
      await _firestoreService.setSubcollectionDocument(
        parentCollection: collectionName,
        parentId: user.uid,
        subcollection: favoritesSubcollection,
        documentId: recipeId,
        data: {'addedAt': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      debugPrint("Error adding favorite: $e");
      rethrow;
    }
  }

  Future<void> removeFavorite(String recipeId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not authenticated");

    try {
      await _firestoreService.deleteSubcollectionDocument(
        parentCollection: collectionName,
        parentId: user.uid,
        subcollection: favoritesSubcollection,
        documentId: recipeId,
      );
    } catch (e) {
      debugPrint("Error removing favorite: $e");
      rethrow;
    }
  }
}
