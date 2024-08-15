import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingoflotto/components/my_appbar.dart';
import 'package:kingoflotto/components/my_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'package:kingoflotto/constants/fonts_constants.dart';
import 'package:kingoflotto/features/admob/ad_service.dart';
import 'package:kingoflotto/pages/signin_page.dart';
import '../constants/color_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/user_service/user_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final AdManager _adManager = AdManager();

  @override
  void initState() {
    super.initState();

    _adManager.initializeBannerAd(
      () {
        setState(() {});
      },
      (ad, error) {
        print('BannerAd failed to load: $error');
      },
    );
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userModelNotifier = ref.read(userModelNotifierProvider.notifier);
    final user = ref.read(authServiceProvider);
    print(user);

    // 상태가 null인 경우에만 fetch 수행
    if (user != null && ref.read(userModelNotifierProvider) == null) {
      userModelNotifier.fetchUser(user.uid);
      print('Fetched!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);
    final userModel = ref.watch(userModelNotifierProvider);

    void goToSignInPage() async {
      await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()));
    }

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
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
          Image.asset(
            'assets/images/lotto_more.png',
            width: 32,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MySizedBox(
                height: 16,
              ),
              (_adManager.isBannerAdReady)
                  ? SizedBox(
                      height: _adManager.bannerAd.size.height.toDouble(),
                      width: _adManager.bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _adManager.bannerAd),
                    )
                  : Container(
                      width: 320,
                      height: 50,
                      color: backGroundColor,
                      child: Center(
                        child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              color: primaryOrange,
                              strokeWidth: 2,
                            )),
                      ),
                    ),
              const MySizedBox(height: 16),
              MyContainer(
                  upperChild: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text('Player License'),
                        Spacer(),
                        Text(''),
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
                            color: Colors.grey, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            user?.photoURL ?? 'https://via.placeholder.com/150',
                            // 기본 이미지 URL
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      ),
                      const MySizedBox(height: 8),
                      Text(
                        userModel?.displayName ?? 'No User',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryBlack),
                      ),
                      const MySizedBox(height: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            border: TableBorder.all(), // 테두리 추가
                            columnWidths: const {
                              0: FlexColumnWidth(3), // 첫 번째 열의 너비
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(3),
                              3: FlexColumnWidth(4),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child:
                                          Text('총 게임수', style: tableTextStyle),
                                    ),
                                  ),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(userModel
                                                  ?.userGames.length
                                                  .toString() ??
                                              '0'))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('당첨 게임수',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                              userModel?.email ?? 'no mail'))),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('적중률',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(userModel?.winningRate
                                                  .toString() ??
                                              '0'))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('최고 성적',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                              userModel?.rank.toString() ??
                                                  'No Rank'))),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('총 지출',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(userModel?.totalSpend
                                                  .toString() ??
                                              '0'))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('총 상금',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(userModel?.totalPrize
                                                  .toString() ??
                                              '0'))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottomHeight: 320),
              ElevatedButton(
                child: const Text('로그아웃또'),
                onPressed: () async {
                  await auth.signOut();
                  goToSignInPage();
                  // 로그아웃 후 필요한 네비게이션 로직 (예: 로그인 페이지로 이동)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
