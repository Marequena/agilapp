import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;

  const AppInput({Key? key, this.label, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
