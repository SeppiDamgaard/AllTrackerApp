import 'package:flutter/material.dart';

class StyledTextButton extends StatelessWidget {
  final Function() callback;
  final String text;
  final double width;
  final double padding;
  final EdgeInsets margin;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const StyledTextButton({
    Key? key, 
    required this.text, 
    required this.callback, 
    required this.backgroundColor, 
    required this.textColor,
    this.borderColor = Colors.transparent, 
    this.width = double.infinity, 
    this.padding = 8, 
    this.margin = const EdgeInsets.symmetric(vertical: 8)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: width,
        child: TextButton(
          style: TextButton.styleFrom(
            side: BorderSide(
              color: borderColor,
              width: 2
            ),
            backgroundColor: backgroundColor
          ),
          onPressed: callback,
          child: Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            )
          ),
        ),
      ),
    );
  }
}