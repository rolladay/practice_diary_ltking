import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  // Flutter 엔진과 바인딩을 보장하는 부분
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase 초기화
    await Firebase.initializeApp();
    // Firebase Crashlytics 초기 설정
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // Flutter 프레임워크 오류를 자동으로 보고하도록 설정
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Dart 비동기 오류를 자동으로 보고하도록 설정
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // 기타 비동기 초기화
    await Future.wait([
      MobileAds.instance.initialize(),
      IsarService().initialize(),
    ],);

    runApp(
      const ProviderScope(child: MyApp()),
    );
  } catch (e, stackTrace) {
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
  } finally {
    FlutterNativeSplash.remove();
  }
}

//My App부분
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto King',
      // ThemeData는 font컬러 이런것보다 BNB 테마라거나, 메인 컬러 설정정도에만!
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryOrange),
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
