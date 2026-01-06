import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/splash_screen/start_screen1.dart';
import 'package:learnify/splash_screen/start_screen2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingWrapper extends StatelessWidget {
  final _controller = PageController();
  OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            children: const [StartScreen1(), StartScreen2()],
          ),
          Positioned(
            bottom: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const JumpingDotEffect(
                spacing: 12,
                dotHeight: 12,
                dotWidth: 12,
                jumpScale: 1.3,
                activeDotColor: Colors.white,
                dotColor: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );  
  }
}
