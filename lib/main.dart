import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingoflotto/constants/color_constants.dart';
import 'package:kingoflotto/features/isar_db/isar_service.dart';
import 'package:kingoflotto/pages/signin_page.dart';




// AppId : ca-app-pub-4861864054452208~3492446155
// Ad Unit Id : ca-app-pub-4861864054452208/4743578952

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // FutuewWait는 비동기 함수를 병렬로 실행시켜 실행시간 단축
    await Future.wait([
      Firebase.initializeApp(),
      MobileAds.instance.initialize(),
      IsarService().initialize(),
    ]);

    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    print('초기화 중 오류 발생: $e');
    // 여기에 오류 처리 로직 추가
  } finally {
    FlutterNativeSplash.remove();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto King',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: primaryOrange),
        splashFactory: InkRipple.splashFactory,
        // BottomNavigationBar 테마 커스터마이징
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black45,
        ),
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}
