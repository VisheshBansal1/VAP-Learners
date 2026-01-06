// lib/services/user_profile_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Live stream of user profile (displayName, email, photoURL, etc.)
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) {
    return _userDoc(uid).snapshots();
  }

  /// Ensure the user doc exists (call after signup or first login)
  Future<void> ensureUserDoc() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _userDoc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Update name + email in Firestore (and Auth email as well)
  Future<void> updateNameEmail({
    required String displayName,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Update Auth email first (can throw "requires-recent-login")
    if (email.isNotEmpty && email != (user.email ?? '')) {
      await user.updateEmail(email);
    }
    if (displayName.isNotEmpty && displayName != (user.displayName ?? '')) {
      await user.updateDisplayName(displayName);
    }
    await user.reload();

    await _userDoc(user.uid).set({
      'displayName': displayName,
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Uploads profile image to Storage and updates Firestore + Auth photoURL
  Future<String> uploadProfileImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final path = 'users/${user.uid}/profile.jpg';
    final task = await _storage.ref(path).putFile(file);
    final url = await task.ref.getDownloadURL();

    await user.updatePhotoURL(url);
    await _userDoc(user.uid).set({
      'photoURL': url,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return url;
  }
}
