import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/constants/colors.dart';

class ForgotPasswordButton extends StatelessWidget {
  final TextEditingController emailController;

  const ForgotPasswordButton({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final email = emailController.text.trim();

          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Enter email to reset password')),
            );
            return;
          }

          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reset link sent to $email'),
                backgroundColor: Colors.green,
              ),
            );
          } on FirebaseAuthException catch (e) {
            final message = e.code == 'user-not-found'
                ? 'No user found for this email.'
                : 'Failed to send reset link.';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: MyColors.buttonColor),
        ),
      ),
    );
  }
}
