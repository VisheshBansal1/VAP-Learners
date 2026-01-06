import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/dashboard.dart';
import 'package:learnify/splash_screen/start_screen3.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StartScreen2 extends StatelessWidget {
  const StartScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.mainColor,
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Step 2 of 3',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 8),

            LinearPercentIndicator(
              lineHeight: 20,
              percent: 0.6,
              progressColor: MyColors.progressBarColor,
              barRadius: Radius.circular(20),
            ),
            SizedBox(height: 20),
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
                  'assets/images/screen2Image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            const Text(
              'Track Your Progress',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Visualize your learning journey,\n celebrate milestones, and stay motivated with personalized AI-driven insights.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return StartScreen3();
                  },
                ),
              );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: MyColors.progressBarColor,
                  shadowColor: MyColors.progressBarColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 35,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextButton(
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
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                ),
                child: Text('Skip', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
