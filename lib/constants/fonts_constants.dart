import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kingoflotto/constants/color_constants.dart';

final TextStyle appBarTitleTextStyle = GoogleFonts.blackHanSans(
  fontSize: 22,
  color: Colors.white,

);

final TextStyle appBarTitleTextStyleWithStroke = GoogleFonts.blackHanSans(
  fontSize: 22,

  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = Colors.black, // 스트로크 색상
);


final TextStyle ballTextStyle = GoogleFonts.blackHanSans(
  fontSize: 21,
  color: Colors.white,
);

final TextStyle ballTextStyleWithStroke = GoogleFonts.blackHanSans(
  fontSize: 21,

  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.black, // 스트로크 색상
);


final TextStyle bigTextStyle = GoogleFonts.blackHanSans(
  fontSize: 32,
  color: primaryYellow,

);

final TextStyle bigTextStyleWithStroke = GoogleFonts.blackHanSans(
  fontSize: 32,

  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.black, // 스트로크 색상
);


final TextStyle bigTextStyle2 = GoogleFonts.blackHanSans(
  fontSize: 72,
  color: primaryYellow,

);

final TextStyle bigTextStyleWithStroke2 = GoogleFonts.blackHanSans(
  fontSize: 72,

  foreground: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.black, // 스트로크 색상
);


const TextStyle tableTextStyle = TextStyle(fontSize: 12);