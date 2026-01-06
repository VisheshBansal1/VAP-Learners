import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnify/ai/choose_carier/screen/tech_comparison_screen.dart';
import 'package:learnify/ai/roadmap_generator/screens/roadmap_generator_screen.dart';

import 'package:learnify/notes/notes_screen/notes_main_screen.dart';

class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const NotesMainScreen();
              },
            ),
          ),
          leading: Icon(CupertinoIcons.book),
          title: Text('Notes'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const RoadmapGeneratorScreen();
              },
            ),
          ),
          leading: Icon(Icons.alt_route_outlined),
          title: Text('RoadMaps'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TechComparisonScreen();
              },
            ),
          ),
          leading: Icon(Icons.alt_route_outlined),
          title: Text('Choose Your Technology'),
          subtitle: Text('Best Choose for you'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        ListTile(
          leading: Icon(Icons.quiz),
          title: Text('Quizes'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        ListTile(
          leading: Icon(Icons.download),
          title: Text('Lectures Downloaded'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}