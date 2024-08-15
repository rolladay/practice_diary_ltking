import 'package:flutter/material.dart';


class SignutureFont extends StatelessWidget {
  const SignutureFont({
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
