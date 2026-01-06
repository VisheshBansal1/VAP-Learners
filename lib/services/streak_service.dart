import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class StreakService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Call this ONCE after successful login
  Future<void> updateLoginStreak() async {
    // if (GuestService.isGuest) return;
    final user = _auth.currentUser;
    if (user == null) return;


    final docRef = _firestore.collection('users').doc(user.uid);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      int newStreak = 1;

      if (snapshot.exists) {
        final data = snapshot.data()!;

        final Timestamp? lastLoginTs = data['lastLoginAt'];
        final int currentStreak = (data['streakCount'] ?? 0) as int;

        if (lastLoginTs != null) {
          final lastLogin = lastLoginTs.toDate();
          final lastDay = DateTime(
            lastLogin.year,
            lastLogin.month,
            lastLogin.day,
          );

          final diff = today.difference(lastDay).inDays;

          // Same day login → do nothing
          if (diff == 0) return;

          // Consecutive day → increment
          if (diff == 1) {
            newStreak = currentStreak + 1;
          }
        }
      }

      // Safe write (does NOT overwrite other fields)
      transaction.set(
        docRef,
        {
          'streakCount': newStreak,
          'lastLoginAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    });
  }
}
