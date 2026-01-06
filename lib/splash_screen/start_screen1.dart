import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/dashboard.dart';

class StartScreen1 extends StatelessWidget {
  const StartScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Image card - takes around 45% of screen height
            Container(
              height: size.height * 0.45,
              width: double.infinity,
              color: Colors.transparent,
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/screen1Image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title text
            const Text(
              'Welcome To VAP Learners',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Experience personalized learning powered by our advanced AI.\nYour educational journey is about to get smarter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
