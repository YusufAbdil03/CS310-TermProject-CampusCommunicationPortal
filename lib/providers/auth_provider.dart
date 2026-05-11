import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/auth_service.dart';

/// AuthProvider
/// ------------
/// ChangeNotifier that exposes Auth state to the whole widget tree.
/// (Rubric: "State Mgmt Setup" + "Auth State" — Provider with
/// ChangeNotifier, affects the whole app.)
///
/// Avoids deep prop-drilling — any screen reads it via
/// `context.watch<AuthProvider>()` or `context.read<AuthProvider>()`.
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  late final StreamSubscription<User?> _authSubscription;

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  AuthProvider() {
    _user = _authService.currentUser;

    // Listen to FirebaseAuth changes and update local state.
    // This is what makes the whole app react when the user
    // logs in or logs out.
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    }, onError: (Object error) {
      _errorMessage = 'Could not load authentication state.';
      _isLoading = false;
      notifyListeners();
    });
  }

  // ---------- Getters used by the UI ----------
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // ---------- Actions ----------

  /// Sign up. Returns true if successful, false otherwise.
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Log in. Returns true if successful.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signIn(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Log out.
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    // _user gets set to null by the authStateChanges listener.
  }

  /// Send a password-reset email. Returns true if sent.
  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.sendPasswordReset(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Clear the last error message (call after showing it once).
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
