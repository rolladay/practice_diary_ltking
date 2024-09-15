import 'package:flutter/material.dart';

import '../constants/color_constants.dart';


class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBlack,
      height: 2.0,
    );
  }
}