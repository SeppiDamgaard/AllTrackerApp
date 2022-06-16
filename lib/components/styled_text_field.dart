import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? placeholder;
  final Function? submitHandler;
  final bool obscureText;
  final bool lastField;
  const StyledTextField({
    Key? key, 
    required this.title, 
    required this.controller, 
    this.placeholder, 
    this.submitHandler, 
    this.obscureText = false,
    this.lastField = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onSubmitted: (_) => submitHandler,
        textInputAction: lastField ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: title,
          contentPadding: const EdgeInsets.all(12),
          hintText: placeholder,
        ),
      ),
    );
  }
}