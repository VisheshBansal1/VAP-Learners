import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: FloatingActionButton.large(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: onPressed,
        child: FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
