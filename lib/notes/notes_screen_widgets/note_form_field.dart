import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';

class NoteFormField extends StatelessWidget {
  const NoteFormField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.filled,
    this.fillColor,
    this.labelText,
    this.suffixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autofocus;
  final bool? filled;
  final Color? fillColor;
  final String? labelText;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      autofocus: autofocus,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: filled,
        fillColor: fillColor,
        hintText: hintText,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.mainColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
    );
  }
}
