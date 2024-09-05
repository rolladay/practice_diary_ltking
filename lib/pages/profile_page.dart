import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kingoflotto/components/my_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'package:kingoflotto/constants/fonts_constants.dart';
import 'package:kingoflotto/features/isar_db/isar_service.dart';
import 'package:kingoflotto/pages/signin_page.dart';
import '../components/ad_banner_widget.dart';
import '../constants/color_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/debug/cache_reset.dart';
import '../features/user_service/user_provider.dart';

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

    print('프로파일페이지 build함수 내 에서 refWatch로 가져온 값 : $userModel');

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
                height: 8,
              ),
              const AdBannerWidget(),
              const MySizedBox(height: 8),
              MyContainer(
                  upperChild: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text('Player License'),
                        Spacer(),
                        Text(
                          'LV 01',
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
                          child: Image.network(
                            user?.photoURL ?? 'https://via.placeholder.com/150',
                            // 기본 이미지 URL
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      ),
                      // 여기서 쓰이는 UserModel은 riverpod에서 가져오는 값이다. 앱 실행시 쭉 관리되는 상태임.
                      // 즉, 로그인 후부터 로그인한 유저의 UserModel 의 state를 가지고 보여주는 부분으로
                      // fireStore와 통신이나 서버간 통신이 없음.
                      const MySizedBox(height: 8),
                      Text(
                        userModel?.displayName ?? 'No User',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryBlack),
                      ),
                      // 여기 유저 comment 들어갈 자리
                      const Text(
                        '난 앞으로도 열심히 살아갈꺼야.',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
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
                                  const TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child:
                                          Text('총 게임수', style: tableTextStyle),
                                    ),
                                  ),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(userModelClass
                                              .getUserGames(userModel!.uid)
                                              .toString()))),
                                  const TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('당첨 게임수',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(userModel.email))),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('적중률',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(userModel.winningRate
                                              .toString()))),
                                  const TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('최고 성적',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child:
                                              Text(userModel.rank.toString()))),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('총 지출',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(userModel.totalSpend
                                              .toString()))),
                                  const TableCell(
                                      child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('총 상금',
                                              style: tableTextStyle))),
                                  TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(userModel.totalPrize
                                              .toString()))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottomHeight: 600),

              // 이 부분은 LottoResult 최근꺼 확인할라고 있는 부분임... 나중에 없앨수도?
              FutureBuilder(
                future: isar.getLatestLottoResult(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // 데이터를 로딩 중일 때 보여줄 위젯
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // 에러 발생 시 보여줄 위젯
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data!.drawDate
                        .toString()); // 데이터가 존재할 때 보여줄 위젯
                  } else {
                    return const Text('No data'); // 데이터가 없을 때 보여줄 위젯
                  }
                },
              ),

              ElevatedButton(
                child: const Text('로그아웃또'),
                onPressed: () async {
                  await auth.signOut();
                  goToSignInPage();
                  // 로그아웃 후 필요한 네비게이션 로직 (예: 로그인 페이지로 이동)
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await deleteAppCache(); // 캐시 삭제 함수 호출
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('캐시가 삭제되었습니다.'),
                    ),
                  );
                },
                child: Text('캐시 삭제'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
