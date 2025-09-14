import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const AppInput({
    Key? key,
    this.label,
    this.controller,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final color = Theme.of(context).cardColor;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
    filled: true,
    fillColor: color.withAlpha((0.95 * 255).round()),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
