import 'package:flutter/material.dart';


class SignutureFont3 extends StatelessWidget {
  const SignutureFont3({
    super.key,
    required this.title,
    required this.textStyle,
    required this.strokeTextStyle,
  });

  final String title;
  final TextStyle textStyle;
  final TextStyle strokeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke Text
        Text(
          title,
          style: textStyle,
        ),
        // Fill Text
        Text(
          title,
          style: strokeTextStyle,
        ),
      ],
    );
  }
}