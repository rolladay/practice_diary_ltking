import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/my_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'package:kingoflotto/constants/fonts_constants.dart';
import 'package:kingoflotto/features/isar_db/isar_service.dart';
import 'package:kingoflotto/pages/setting_page.dart';
import 'package:kingoflotto/pages/signin_page.dart';
import '../components/ad_banner_widget.dart';
import '../components/signiture_font.dart';
import '../constants/color_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/debug/cache_reset.dart';
import '../features/lotto_service/lotto_functions.dart';
import '../features/user_service/user_provider.dart';
import '../models/user_model/user_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final isar = IsarService();

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);
    final userModel = ref.watch(userModelNotifierProvider);
    final userModelClass = ref.watch(userModelNotifierProvider.notifier);

    void goToSignInPage() async {
      await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()));
    }

    Widget buildTopNumbers(UserModel user) {
      // coreNos에서 가장 빈도가 높은 6개의 번호 추출
      final numberFrequency =
          user.coreNos!.fold<Map<int, int>>({}, (map, number) {
        map[number] = (map[number] ?? 0) + 1;
        return map;
      });

      final topNumbers = numberFrequency.keys.toList() // 숫자만 추출하여 리스트로 변환
        ..sort((a, b) =>
            numberFrequency[b]!.compareTo(numberFrequency[a]!)) // 빈도순으로 정렬
        ..take(6) // 상위 6개 숫자 선택
            .toList();

      print('넘버프리퀀시 : $numberFrequency');
      print('넘버프리퀀시 엔트리 : ${numberFrequency.entries}');
      print('coreNos: ${userModel!.coreNos}');
      print('탑넘버: $topNumbers');

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: topNumbers.map((number) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryYellow,
                child: SignutureFont(
                  title: number.toString(),
                  textStyle: ballTextStyle,
                  strokeTextStyle: ballTextStyleWithStroke,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                // Stroke Text
                Text(
                  '프로필',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
                Text(
                  '프로필',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SettingPage(),
                  transitionDuration: Duration.zero,  // 애니메이션 시간 0으로 설정
                  reverseTransitionDuration: Duration.zero,  // 뒤로 갈 때도 애니메이션 없이
                ),
              );
            },
            child: Image.asset(
              'assets/images/profile_setting.png',
              width: 32,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black, // 라인 색상
            height: 1.0, // 라인 두께
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const MySizedBox(height: 8),
            const AdBannerWidget(),
            const MySizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyContainer(
                        upperChild: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text('Player License'),
                              Spacer(),
                              Text(
                                'Lv. 01',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        bottomChild: Column(
                          children: [
                            const MySizedBox(height: 16),
                            Container(
                              width: 100.0, // 이미지의 너비
                              height: 100.0, // 이미지의 높이
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black54, // 테두리 색상
                                  width: 1.5, // 테두리 두께
                                ),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user?.photoURL ??
                                      'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                  placeholder: (context, url) =>
                                      const Icon(Icons.downloading),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            // 여기서 쓰이는 UserModel은 riverpod에서 가져오는 값이다. 앱 실행시 쭉 관리되는 상태임.
                            // 즉, 로그인 후부터 로그인한 유저의 UserModel 의 state를 가지고 보여주는 부분으로
                            // fireStore와 통신이나 서버간 통신이 없음.
                            const MySizedBox(height: 8),
                            Text(
                              userModel!.displayName ?? 'No User',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlack),
                            ),
                            // 여기 유저 comment 들어갈 자리
                            SizedBox(
                              height: 32,
                              width: 240,
                              child: Center(
                                child: Text(
                                  userModel.userComment,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.black45,
                              ),
                            ),
                            const MySizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 92,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: primaryGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 적중률 소숫점3자리까지만
                                        Text(
                                          '${userModel.winningRate != null ? userModel.winningRate!.toStringAsFixed(3) : "0.000"}%',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '적중률',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: 92,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: primaryGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formatTotalPrize(
                                              userModel.totalPrize),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '총상금',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 총경험치
                                  Container(
                                    width: 92,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: primaryGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${userModel.exp != null ? userModel.exp!.toInt() : 0}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '경험치',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MySizedBox(height: 16),
                            const Text(
                              'Lucky Numbers',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const MySizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: double.infinity,
                                height: 54,
                                child: buildTopNumbers(userModel),
                              ),
                            ),
                          ],
                        ),
                        bottomHeight: 376),

                  ],
                ),
              ),
            ),
            MyBtnContainer(
              color: specialBlue,
              child: const Center(
                child: Text(
                  '업그레이드',
                  style: btnTextStyle,
                ),
              ),
            ),
            const MySizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
