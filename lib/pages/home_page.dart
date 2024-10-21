import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/pages/profile_page.dart';
import 'package:kingoflotto/pages/rank_page.dart';
import 'package:kingoflotto/pages/draw_page.dart';
import '../constants/color_constants.dart';
import '../constants/my_bnb_list.dart';
import 'lotto_page.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 홈페이지로 랜딩 후 처음 보여줄 화면 > LottoPage로 설정
  int _selectedIndex = 1;
  DateTime? currentBackPressTime;

  static final List<Widget> _widgetOptions = [
    const RankPage(),
    const LottoPage(),
    const DrawPage(),
    const ProfilePage(),
  ];

  Future<void> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              '뒤로가기 버튼을 한번 더 누르면 앱이 종료됩니다'),
          duration: const Duration(seconds: 2),
          // action: SnackBarAction(
          //   label: '확인',
          //   onPressed: () {
          //     // 액션 버튼을 눌렀을 때의 동작
          //   },
          // ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      _exitApp();
    }
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void _onBnbItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // 특정 화면에서 시스템 네비게이션 바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor:
            Color.fromARGB(255, 216, 89, 37), // 원하는 색상으로 변경
        systemNavigationBarIconBrightness:
            Brightness.light, // 아이콘 색상 (밝은 배경일 때 어두운 아이콘)
      ),
    );
  }

  @override
  void dispose() {
    // 화면을 떠날 때 시스템 네비게이션 바 색상 초기화
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black12, // 기본 색상으로 변경
      systemNavigationBarIconBrightness: Brightness.dark, // 기본 아이콘 색상
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onWillPop();
      },
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black,
              height: 1,
              width: double.infinity,
            ),
            BottomNavigationBar(
              selectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              type: BottomNavigationBarType.fixed,
              backgroundColor: primaryOrange,
              items: myBnbList,
              currentIndex: _selectedIndex,
              onTap: _onBnbItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
