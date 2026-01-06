import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  //create google-sign-in instance
  final googleSignIn = GoogleSignIn();

  //Method to sign in using Google
  Future<bool> signInWithGoogle() async {
    // ✅ always ask for account selection
    await googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn()
          .signIn();

      //Check if the user cancelled the sign in
      if (googleSignInAccount == null) {
        return false; //user cancelled
      }

      //get authentication token
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //create a firebase credential using the token from google

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      //sign in to firebase using google credential
      await auth.signInWithCredential(authCredential);
      return true; // Sign-in Successfully
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false; // error occurred
      // throw e
    }
  }

  // Method to signOut from both firebase and google
  googleSignOut() async {
    //SignOut from firebase
    await auth.signOut();
    //from Google
    await googleSignIn.signOut();
  }
}
