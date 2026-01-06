import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= MODE =================

  bool _isRegisterMode = true;
  bool get isRegisterMode => _isRegisterMode;
  set isRegisterMode(bool value) {
    _isRegisterMode = value;
    notifyListeners();
  }

  // ================= PASSWORD VISIBILITY =================

  bool _isPasswordHidden = true;
  bool get isPasswordHidden => _isPasswordHidden;
  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    notifyListeners();
  }

  // ================= AUTH ACTION =================

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (_isRegisterMode) {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // optional but useful
        await cred.user?.updateDisplayName(name);
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code}');
      rethrow;
    }
  }
}
