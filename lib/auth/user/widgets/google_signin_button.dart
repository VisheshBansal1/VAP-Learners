import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const GoogleSignInButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Card(
        color: MyColors.buttonColor,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/google-logo.png', height: 28),
              const SizedBox(width: 12),
              Text(
                isLoading ? 'Signing In...' : 'Continue with Google',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
