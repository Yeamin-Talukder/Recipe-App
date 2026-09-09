import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final UserRepository _repository;
  List<String> _favoriteIds = [];
  bool _isLoading = false;
  String? _error;

  FavoriteProvider({required UserRepository repository}) : _repository = repository;

  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFavorites() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteIds = await _repository.getFavorites();
    } catch (e) {
      _error = 'Failed to load favorites';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Called when the user signs in so we reload their personal favorites.
  Future<void> reloadForUser() async {
    _favoriteIds = [];
    notifyListeners();
    await fetchFavorites();
  }

  Future<void> toggleFavorite(String recipeId) async {
    final isFav = _favoriteIds.contains(recipeId);

    // Optimistic UI update
    if (isFav) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();

    try {
      if (isFav) {
        await _repository.removeFavorite(recipeId);
      } else {
        await _repository.addFavorite(recipeId);
      }
    } catch (e) {
      // Revert on failure
      if (isFav) {
        _favoriteIds.add(recipeId);
      } else {
        _favoriteIds.remove(recipeId);
      }
      _error = 'Failed to update favorite status';
      notifyListeners();
    }
  }

  bool isFavorite(String recipeId) {
    return _favoriteIds.contains(recipeId);
  }

  int get count => _favoriteIds.length;
}
