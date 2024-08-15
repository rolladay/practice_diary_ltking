import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class MyContainer extends StatelessWidget {
  const MyContainer(
      {super.key,
      required this.upperChild,
      required this.bottomChild,
      required this.bottomHeight});

  final Widget upperChild;
  final Widget bottomChild;
  final double bottomHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 36,
          decoration: BoxDecoration(
            color: secondOrange,
            border: Border.all(color: primaryBlack),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: upperChild
        ),
        Container(
          width: double.infinity,
          height: bottomHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: primaryBlack),
              right: BorderSide(color: primaryBlack),
              bottom: BorderSide(color: primaryBlack),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: bottomChild,
        )
      ],
    );
  }
}
