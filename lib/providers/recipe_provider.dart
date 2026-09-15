import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository;

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  Timer? _debounce;
  StreamSubscription<List<Recipe>>? _recipeSub;

  RecipeProvider({required RecipeRepository repository})
      : _repository = repository;

  // Getters
  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Recipe> get filteredRecipes {
    return _recipes.where((recipe) {
      final matchesCategory =
          _selectedCategory == 'All' || recipe.category == _selectedCategory;

      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          recipe.name.toLowerCase().contains(query) ||
          recipe.ingredients.any(
              (ing) => ing.name.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ── Subscribe to real-time stream ─────────────────────────────────────────

  /// Called once at startup. Subscribes to the Firestore recipes stream so
  /// any change (e.g. updated rating/reviews after a review is added) is
  /// reflected immediately in the card grid.
  bool _reviewsSeeded = false;

  void subscribeToRecipes() {
    if (_recipeSub != null) return; // already subscribed

    _isLoading = true;
    _error = null;
    notifyListeners();

    _recipeSub = _repository.streamRecipes().listen(
      (data) {
        if (data.length < 30) {
          // Firestore empty / under-populated — seed & fall back to mock data
          _repository.seedMockData().then((_) => fetchRecipes());
        } else {
          _recipes = data;
          _isLoading = false;
          _error = null;
          notifyListeners();

          // Seed demo reviews once per app session (idempotent on Firestore side)
          if (!_reviewsSeeded) {
            _reviewsSeeded = true;
            _repository.seedDemoReviews();
          }
        }
      },
      onError: (e) {
        _error = 'Failed to load recipes. Please try again.';
        _isLoading = false;
        notifyListeners();
        // Attempt one-shot fallback
        fetchRecipes();
      },
    );
  }

  // ── One-shot fetch (fallback / pull-to-refresh) ───────────────────────────

  Future<void> fetchRecipes() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _repository.getRecipes();
    } catch (e) {
      _error = 'Failed to load recipes. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set Search Query with Debounce
  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_searchQuery != query) {
        _searchQuery = query;
        notifyListeners();
      }
    });
  }

  // Set Category
  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _recipeSub?.cancel();
    super.dispose();
  }
}

