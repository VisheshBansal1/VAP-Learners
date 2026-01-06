import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/user/dialogs/password_dialog.dart';
import 'package:learnify/auth/user/services/google_auth.dart';
import 'package:learnify/auth/user/services/internet_con.dart';
import 'package:learnify/auth/user/widgets/app_logo_section.dart';
import 'package:learnify/auth/user/widgets/divider_widget.dart';
import 'package:learnify/auth/user/widgets/email_password_form.dart';
import 'package:learnify/auth/user/widgets/forgot_password_button.dart';
import 'package:learnify/auth/user/widgets/google_signin_button.dart';
import 'package:learnify/auth/user/widgets/term_text.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/dashboard.dart';
import 'package:learnify/services/streak_service.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final InternetChecker _checker = InternetChecker();

  bool isLoading = false;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checker.startListening();
  }

  @override
  void dispose() {
    _checker.stopListening();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---- GOOGLE SIGN IN ----
  Future<void> handleGoogleSignIn() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final result = await FirebaseServices().signInWithGoogle();
      if (!result) throw 'Google sign-in cancelled';

      final user = _auth.currentUser;
      if (user == null) {
        throw 'Authentication failed. Please try again.';
      }

      final providers = user.providerData.map((e) => e.providerId).toList();

      // PASSWORD NOT LINKED
      if (!providers.contains('password')) {
        final password = await showPasswordDialog(context);

        // 🚨 USER CANCELLED → FULL ABORT
        if (password == null) {
          await _safeLogout();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password setup cancelled. Sign-in aborted.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }

        await user.linkWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password),
        );
      }

      await createUserDocumentIfNotExists();

      await StreakService().updateLoginStreak();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _safeLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}
  }

  // ---- EMAIL SIGN IN ----
  Future<void> handleEmailSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
 
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.code)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> createUserDocumentIfNotExists() async {
    final user = _auth.currentUser!;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    if (!(await doc.get()).exists) {
      await doc.set({
        'name': user.displayName ?? 'New User',
        'email': user.email,
        'profileImage': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const AppLogoSection(),
              GoogleSignInButton(
                isLoading: isLoading,
                onTap: handleGoogleSignIn,
              ),
              SizedBox(height: 15),
              const DividerWidget(),
              EmailPasswordForm(
                formKey: _formKey,
                emailController: emailController,
                passwordController: passwordController,
                obscurePassword: obscurePassword,
                onTogglePassword: () =>
                    setState(() => obscurePassword = !obscurePassword),
                onSignIn: handleEmailSignIn,
                isLoading: isLoading,
              ),

              ForgotPasswordButton(emailController: emailController),
              SizedBox(height: 10),
              const TermsText(),
            ],
          ),
        ),
      ),
    );
  }
}