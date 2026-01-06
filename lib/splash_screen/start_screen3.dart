import 'package:flutter/material.dart';
import 'package:learnify/auth/user/screens/login_screen.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/dashboard.dart';

class StartScreen3 extends StatelessWidget {
  const StartScreen3({super.key});

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
            child: Text('Skip', style: TextStyle(color: Colors.white38)),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                'assets/images/screen3Image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          const Text(
            'Challenge Your\nFriends',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Turn learning into a friendly competition.\nTrack your progress on leaderboards and motivate each other to reach new goals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          // SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserLoginScreen();
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
              child: Text(
                'Continue →',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
