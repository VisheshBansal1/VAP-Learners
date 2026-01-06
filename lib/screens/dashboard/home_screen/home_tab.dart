import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/home_screen/home_tab_sections/build_recommended_card.dart';
import 'package:learnify/screens/dashboard/home_screen/home_tab_sections/continue_learning_sections.dart';
import 'package:learnify/screens/dashboard/home_screen/home_tab_sections/build_info_card.dart';
import 'package:learnify/screens/dashboard/home_screen/home_tab_sections/build_top_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTopSection(context),
              buildInfoCards(),
              ContinueLearningSection(),
              RecommendedSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
