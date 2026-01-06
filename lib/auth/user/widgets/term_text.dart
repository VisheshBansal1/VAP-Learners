import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "By continuing, you agree to Learnify",
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
          children: const [
            TextSpan(
              text: "Terms of Service",
              style: TextStyle(color: Color(0xFF9B8CFF)),
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(color: Color(0xFF9B8CFF)),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
