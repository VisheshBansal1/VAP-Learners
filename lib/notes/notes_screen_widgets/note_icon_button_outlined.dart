
import 'package:flutter/material.dart';

class NoteIconButtonOutlined extends StatelessWidget {
  const NoteIconButtonOutlined({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final void Function()? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        elevation: 2,
        side: BorderSide(color: Colors.black),
      ),
      child: icon,
    );
  }
}
