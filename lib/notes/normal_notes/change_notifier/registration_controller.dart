import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= MODE =================

  bool _isRegisterMode = true;
  bool get isRegisterMode => _isRegisterMode;

  void toggleMode() {
    _isRegisterMode = !_isRegisterMode;
    notifyListeners();
  }

  // ================= PASSWORD VISIBILITY =================

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  // ================= LOADING =================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  // ================= AUTH ACTION =================

  Future<String?> submit({
    String? name,
    required String email,
    required String password,
  }) async {
    if (_isLoading) return null;

    _setLoading(true);

    try {
      if (_isRegisterMode) {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        if (name != null && name.trim().isNotEmpty) {
          await cred.user?.updateDisplayName(name.trim());
        }
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (_) {
      return 'Something went wrong. Try again.';
    } finally {
      _setLoading(false);
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ================= ERROR MAPPING =================

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return 'Authentication failed';
    }
  }
}
