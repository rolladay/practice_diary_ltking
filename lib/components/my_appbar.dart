import 'package:flutter/material.dart';
import 'package:kingoflotto/components/signiture_font.dart';

import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';


//현재 사용하고 있지 않음
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBartitle;
  final String? appBarIconPath;
  final VoidCallback? onIconTap;

  const MyAppBar({
    super.key,
    required this.appBartitle,
    this.appBarIconPath,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryOrange,
      centerTitle: true,
      title: Column(
        children: [
          const SizedBox(height: 8,),
          SignutureFont(title: appBartitle, textStyle: appBarTitleTextStyle, strokeTextStyle: appBarTitleTextStyleWithStroke, ),
        ],
      ),
      actions: [
        if (appBarIconPath != null) // appBarIconPath가 null이 아닌 경우에만 아이콘 표시
          GestureDetector(
            onTap: onIconTap, // 아이콘 탭 시 실행할 함수
            child: Image.asset(
              appBarIconPath!,
              width: 32,
            ),
          ),
        const SizedBox(
          width: 16,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.black, // 라인 색상
          height: 1.0, // 라인 두께
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}

