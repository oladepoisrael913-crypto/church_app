import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscuretext;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? labelText;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuretext,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.labelText,
    required Null Function(dynamic value) onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        keyboardType: keyboardType,
        maxLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: hintText,
          suffixIcon: suffixIcon,
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        ),
      ),
    );
  }
}
