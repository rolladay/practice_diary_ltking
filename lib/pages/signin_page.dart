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
  // 유저체크해서
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor:
              Color.fromARGB(255, 216, 89, 37), // 원하는 색상으로 변경
          systemNavigationBarIconBrightness:
              Brightness.light, // 아이콘 색상 (밝은 배경일 때 어두운 아이콘)
        ),
      );
      _checkCurrentUser();
    });
  }

  // 이걸 분리하려면 riverpod 이용해서 user_service를 아예 새로 만들어서 사용해야함.
  Future<void> _checkCurrentUser() async {
    //AuthService Class의 build 메소드의 반환값(=state)를 user에 담는다. 이 경우에는 user 는 auth의 currentUser
    final user = ref.read(authServiceProvider);
    // userModel 객체(앱내 상태관리 할 유저객체)는 user_provider 클래스 자체
    final userModel = ref.watch(userModelNotifierProvider.notifier);

    if (user != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DateTime now = DateTime.now();
      // 업데이트할 데이터 준비
      final Map<String, dynamic> userData = {
        'lastSignedIn': now,
      };
      // Firestore 문서 업데이트
      await firestore.collection('users').doc(user.uid).update(userData);
      userModel.fetchUser(user.uid);
      //UserModel 상태관리 클래스의 처음 접근, 초기값은 null
      print(ref.read(userModelNotifierProvider));
      print('123');

      // 2초 후 HomePage로 이동
      Timer(const Duration(seconds: 1), navigateToHome);
    } // 로그인된 사용자가 없으면 아무 동작도 하지 않음
  }



  Future<void> signIn(BuildContext context) async {
    final userClass = ref.watch(authServiceProvider.notifier);
    final userModel = ref.watch(userModelNotifierProvider.notifier);
    try {
      await userClass.signInWithGoogle();
      final user = ref.read(authServiceProvider);
      if (user != null) {
        userModel.fetchUser(user.uid);
        navigateToHome();
      }
      print('1');
      print(user);
      print('2');

    } catch (e) {
      // 비동기 작업이 완료된 후에 SnackBar를 표시
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
    //current user
    final user = ref.watch(authServiceProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const MySizedBox(
                  height: 160,
                ),
                Image.asset(
                  'assets/images/launcher_ball.png',
                  width: 80,
                ),
                const MySizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/launcher_title.png',
                  width: 160,
                ),
                const MySizedBox(
                  height: 20,
                ),
                const Text(
                  'AI와 동지,조수들의 기운으로\n 1등 당첨되어 왕처럼 살자',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => signIn(context),
                  child: MyBtnContainer(
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/images/launcher_googlelogo.png',
                          width: 40,
                        ),
                        Expanded(
                          child: Center(
                            child: user == null
                                ? const Text(
                                    'Sign-In with Google',
                                  )
                                : Text('SignIn with ${user.displayName}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const MySizedBox(
                  height: 40,
                ),
                const Text(
                  '롤러대 부속 로또연구소',
                  style: TextStyle(color: Colors.white),
                ),
                const MySizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
