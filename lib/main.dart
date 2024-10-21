import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kingoflotto/constants/color_constants.dart';
import 'package:kingoflotto/features/isar_db/isar_service.dart';
import 'package:kingoflotto/pages/signin_page.dart';

// AppId : ca-app-pub-4861864054452208~3492446155
// Ad Unit Id : ca-app-pub-4861864054452208/4743578952
// 역대 로또 당첨번호 : https://signalfire85.tistory.com/28

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Future.wait([
      Firebase.initializeApp(),
      InAppPurchase.instance.isAvailable(),
      MobileAds.instance.initialize(),
      IsarService().initialize(),
    ]);

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
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
        colorScheme: ColorScheme.fromSeed(seedColor: primaryOrange),
        splashFactory: InkRipple.splashFactory,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black45,
        ),
      ),
      home: const SignInPage(),
    );
  }
}
