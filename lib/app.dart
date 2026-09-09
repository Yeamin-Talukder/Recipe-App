import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/settings_provider.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/main_screen.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return MaterialApp(
      title: 'Food Recipe',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      darkTheme: darkTheme(),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const _AuthGate(),
    );
  }
}

/// Routes the user to [LoginScreen] or [MainScreen] based on auth state.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    // Wire FavoriteProvider into AuthProvider so favorites reload on sign-in/out
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final favoriteProvider = context.read<FavoriteProvider>();
      authProvider.bindFavoriteProvider(favoriteProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.hasAccess) {
      return const MainScreen();
    }
    return const LoginScreen();
  }
}
