import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';

class EmailPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignIn;
  final bool isLoading;

  const EmailPasswordForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // EMAIL
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.white54),
              hintText: 'Enter your email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Invalid email format';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // PASSWORD
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white54),
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),

          const SizedBox(height: 40),

          // SIGN IN BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.buttonColor,
              ),
              child: Text(
                isLoading ? 'Signing In...' : 'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
