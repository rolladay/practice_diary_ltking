import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class MySettingList extends StatelessWidget {
  const MySettingList({
    super.key,
    required this.listKey,
    required this.listValue,
  });

  final String listKey;
  final String listValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Row를 수직 중앙에 위치시킴
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listKey,
                  style: const TextStyle(fontSize: 14, color: Colors.black45),
                ),
                Text(
                  listValue,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Row와 아래 노란색 줄 사이에 공간을 만듦
          Container(
            color: Colors.grey,
            height: 0.5,
          ),
        ],
      ),
    );
  }
}
