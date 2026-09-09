import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class MealPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;

  MealPlanRepository({required AuthService authService})
      : _authService = authService;

  String? get _uid => _authService.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _weekRef {
    final uid = _uid;
    if (uid == null) throw Exception('User not signed in');
    final weekKey = _currentWeekKey();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('meal_plans')
        .doc(weekKey)
        .collection('entries');
  }

  String _currentWeekKey() {
    final now = DateTime.now();
    // Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  /// Returns a map of {day_slot -> recipeId} e.g. {"monday_breakfast" -> "recipeId123"}
  Future<Map<String, String>> loadWeekPlan() async {
    try {
      final snapshot = await _weekRef.get();
      return {for (var doc in snapshot.docs) doc.id: doc.data()['recipeId'] as String};
    } catch (e) {
      return {};
    }
  }

  Future<void> setMeal(String day, String slot, String recipeId) async {
    final key = '${day}_$slot';
    await _weekRef.doc(key).set({'recipeId': recipeId, 'day': day, 'slot': slot});
  }

  Future<void> removeMeal(String day, String slot) async {
    final key = '${day}_$slot';
    await _weekRef.doc(key).delete();
  }
}
