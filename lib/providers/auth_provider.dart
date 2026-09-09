import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import 'favorite_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  FavoriteProvider? _favoriteProvider;

  User? _user;
  bool _isLoading = false;
  bool _isGuest = false;
  String? _error;

  AuthProvider({required AuthService authService}) : _authService = authService {
    _authService.authStateChanges.listen((user) async {
      final wasSignedOut = _user == null;
      _user = user;
      // If a real Firebase user signed in, we are no longer a guest
      if (user != null) {
        _isGuest = false;
      }
      notifyListeners();

      // When a new user signs in, reload their favorites
      if (user != null && wasSignedOut && _favoriteProvider != null) {
        await _favoriteProvider!.reloadForUser();
      }
      // When user signs out, clear favorites
      if (user == null && _favoriteProvider != null) {
        _favoriteProvider!.reloadForUser();
      }
    });
  }

  /// Call this once from the widget tree to wire up the FavoriteProvider.
  void bindFavoriteProvider(FavoriteProvider fp) {
    _favoriteProvider = fp;
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSignedIn => _user != null;
  bool get isGuest => _isGuest;
  bool get hasAccess => isSignedIn || _isGuest;

  void continueAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _isGuest = false; // leaving guest mode
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      // Auth state listener will handle setting _user and notifyListeners
    } catch (e) {
      _error = 'Sign-in failed. Please try again.';
      _isGuest = false; // stay signed out, not guest
      debugPrint("AuthProvider signInWithGoogle error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _isGuest = false;
    notifyListeners();
    await _authService.signOut();
    _isLoading = false;
    notifyListeners();
  }
}
