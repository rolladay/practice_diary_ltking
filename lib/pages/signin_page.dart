import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/features/auth/auth_service.dart';
import 'package:kingoflotto/features/user_service/user_provider.dart';
import '../components/my_btn_container.dart';
import '../components/my_sizedbox.dart';
import 'home_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromARGB(255, 216, 89, 37),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
      await _initializeUser();
    });
  }

  // user정보 초기화해주는 걸 SignIn Page에서 해주는 것
  Future<void> _initializeUser() async {
    final authUser = ref.read(authServiceProvider);
    final userModelNotifier = ref.read(userModelNotifierProvider.notifier);

    if (authUser != null) {
      // Fetch user data > UserModel의 퓨쳐 반환
      await userModelNotifier.fetchUser(authUser.uid);
      // Update last signed in
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DateTime now = DateTime.now();
      final Map<String, dynamic> userData = {
        'lastSignedIn': now,
        // 'irukke' : 'hamyundoie' - 이 키가 없으면 생성 있으면 업뎃. 오케이?
      };
      await firestore.collection('users').doc(authUser.uid).update(userData);
      // Navigate to home after a delay
      Timer(const Duration(seconds: 1), navigateToHome);
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      await ref.read(authServiceProvider.notifier).signInWithGoogle();
      // 상태가 업데이트된 후 상태 변화를 감지하도록 설정
      final authUser = ref.read(authServiceProvider);
      final userModelNotifier = ref.read(userModelNotifierProvider.notifier);

      if (authUser != null) {
        await userModelNotifier.fetchUser(authUser.uid);
        navigateToHome();
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Sign-In : $e'),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authServiceProvider); // 상태 변화를 감지하도록 설정

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const MySizedBox(height: 160),
                Image.asset('assets/images/launcher_ball.png', width: 80),
                const MySizedBox(height: 20),
                Image.asset('assets/images/launcher_title.png', width: 160),
                const MySizedBox(height: 20),
                const Text(
                  'AI와 동지,조수들의 기운으로\n 1등 당첨되어 왕처럼 살자',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => signIn(context),
                  child: MyBtnContainer(
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Image.asset('assets/images/launcher_googlelogo.png', width: 40),
                        Expanded(
                          child: Center(
                            child: user == null
                                ? const Text('Sign-In with Google')
                                : Text('SignIn with ${user.displayName}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const MySizedBox(height: 40),
                const Text('롤러대 부속 로또연구소', style: TextStyle(color: Colors.white)),
                const MySizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}