import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final Color labelColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final bool obscureText;

  const AppTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.textColor = Colors.black, // Change text color
    this.labelColor = Colors.black, // Change label color
    this.borderColor = Colors.black, // Change border color
    this.focusedBorderColor = Colors.blue,
    this.fillColor = Colors.transparent,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }
}
