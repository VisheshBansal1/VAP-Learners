import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';

class NoteButton extends StatelessWidget {
  const NoteButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            color: isOutlined ? MyColors.mainColor : Colors.black,
          ),
        ],
      ),

      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: isOutlined ? Colors.white : MyColors.mainColor,
          foregroundColor: !isOutlined ? Colors.white : MyColors.mainColor,
          side: BorderSide(
            color: isOutlined ? MyColors.mainColor : Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
