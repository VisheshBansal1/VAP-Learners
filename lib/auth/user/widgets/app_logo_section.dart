import 'package:flutter/material.dart';

class AppLogoSection extends StatelessWidget {
  const AppLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Image.asset(
          'assets/logos/App_logo.jpg',
          height: height * 0.18,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Text(
          'VAP Learners',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Powered By AI',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          ),
        ),
        SizedBox(height: height * 0.04),
      ],
    );
  }
}
