import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart' as app_auth;
import 'providers/favorite_provider.dart';
import 'providers/meal_plan_provider.dart';
import 'providers/quantity_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/settings_provider.dart';
import 'repositories/meal_plan_repository.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/user_repository.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  final authService = AuthService();
  final recipeRepository = RecipeRepository();
  final userRepository = UserRepository(authService: authService);
  final mealPlanRepository = MealPlanRepository(authService: authService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => app_auth.AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(repository: recipeRepository)..fetchRecipes(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(repository: userRepository)..fetchFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => MealPlanProvider(repository: mealPlanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => QuantityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const RecipeApp(),
    ),
  );
}
