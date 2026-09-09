import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../repositories/meal_plan_repository.dart';

class MealPlanProvider extends ChangeNotifier {
  final MealPlanRepository _repository;

  // day -> slot -> recipe
  final Map<String, Map<String, Recipe>> _plan = {};
  bool _isLoading = false;
  String? _error;

  static const List<String> days = [
    'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'
  ];
  static const List<String> slots = ['breakfast', 'lunch', 'dinner'];

  MealPlanProvider({required MealPlanRepository repository})
      : _repository = repository;

  Map<String, Map<String, Recipe>> get plan => _plan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Recipe? getRecipe(String day, String slot) => _plan[day]?[slot];

  bool hasAnyMealOnDay(String day) => _plan[day]?.isNotEmpty == true;

  int get totalMealsPlanned {
    int count = 0;
    for (var dayMap in _plan.values) { count += dayMap.length; }
    return count;
  }

  Future<void> loadWeekPlan(List<Recipe> allRecipes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final entries = await _repository.loadWeekPlan();
      _plan.clear();

      for (final entry in entries.entries) {
        // key format: "monday_breakfast"
        final parts = entry.key.split('_');
        if (parts.length < 2) { continue; }
        final day = parts[0];
        final slot = parts.sublist(1).join('_');
        final recipe = allRecipes.where((r) => r.id == entry.value).firstOrNull;
        if (recipe != null) {
          _plan.putIfAbsent(day, () => {})[slot] = recipe;
        }
      }
    } catch (e) {
      _error = 'Failed to load meal plan';
      debugPrint('MealPlanProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setMeal(String day, String slot, Recipe recipe) async {
    // Optimistic update
    _plan.putIfAbsent(day, () => {})[slot] = recipe;
    notifyListeners();

    try {
      await _repository.setMeal(day, slot, recipe.id);
    } catch (e) {
      // Revert on failure
      _plan[day]?.remove(slot);
      _error = 'Failed to save meal';
      notifyListeners();
    }
  }

  Future<void> removeMeal(String day, String slot) async {
    final removed = _plan[day]?.remove(slot);
    if (_plan[day]?.isEmpty == true) _plan.remove(day);
    notifyListeners();

    try {
      await _repository.removeMeal(day, slot);
    } catch (e) {
      // Revert on failure
      if (removed != null) {
        _plan.putIfAbsent(day, () => {})[slot] = removed;
      }
      _error = 'Failed to remove meal';
      notifyListeners();
    }
  }

  void clearPlan() {
    _plan.clear();
    notifyListeners();
  }
}
