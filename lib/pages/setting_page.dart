import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'package:kingoflotto/models/user_model/user_model.dart';
import 'package:kingoflotto/pages/signin_page.dart';
import '../components/my_divider.dart';
import '../components/my_setting_list.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/debug/cache_reset.dart';
import '../features/user_service/user_provider.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  late final AuthService auth;

  @override
  void initState() {
    super.initState();
    auth = ref.read(authServiceProvider.notifier);
  }

  void goToSignInPage(BuildContext context) async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  void _handleSignOut(BuildContext context) async {
    await auth.signOut();
    if (context.mounted) {
      goToSignInPage(context);
    }
  }

  void _handleCacheDelete(BuildContext context) async {
    await deleteAppCache();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('캐시가 삭제되었습니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.read(userModelNotifierProvider);
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset('assets/images/common_back.png', width: 32),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                Text(
                  '설정',
                  style: appBarTitleTextStyleWithStroke,
                ),
                Text(
                  '설정',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MySizedBox(height: 16),
            Text(
              '서비스 정책',
              style: settingTitleTextStyle,
            ),
            const MySizedBox(height: 4),
            const MyDivider(),
            const MySizedBox(height: 4),
            const MySettingList(
              listKey: '로또왕 사용가이드',
              listValue: '보기',
            ),
            const MySettingList(
              listKey: '이용약관',
              listValue: '보기',
            ),
            const MySettingList(
              listKey: '고객의 소리',
              listValue: 'rolladay.cs@gmail.com',
            ),
            Spacer(),
            const Text(''),
            ElevatedButton(
              child: const Text('로그아웃'),
              onPressed: () {
                _handleSignOut(context);
              },
            ),
            ElevatedButton(
              onPressed: () {
                _handleCacheDelete(context);
              },
              child: const Text('캐시 삭제'),
            ),
          ],
        ),
      ),
    );
  }
}

