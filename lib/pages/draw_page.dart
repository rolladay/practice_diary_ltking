import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'number_select_page.dart';
import '../components/my_btn_container.dart';
import '../components/no_lotto_noti.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/lotto_service/lotto_result_manager.dart';
import '../features/lotto_service/ocr_services.dart';
import '../features/lotto_service/usergame_manager.dart';
import '../features/user_service/user_provider.dart';
import '../models/lotto_result_model/lotto_result.dart';
import '../models/user_game_model/user_game.dart';
import '../models/user_model/user_model.dart';

class DrawPage extends ConsumerStatefulWidget {
  const DrawPage({super.key});

  @override
  ConsumerState<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends ConsumerState<DrawPage> {
  UserModel? _user;

  // 다음로또회차(+1) 하기위한 현재(결과가 나온) 로또리절트 객체
  LottoResult? _nextLottoResult;
  List<UserGame> loadedUserGames = [];

  bool _isLoading = true; // 로딩 상태를 추적하는 변수
  String? _errorMessage; // 에러 메시지를 저장하는 변수

  final ImagePicker _picker = ImagePicker();
  List<List<int>> extractedNumbers = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    // 데이터를 초기화하는 함수 호출
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 여기에 ref.read 사용 - initState에서는 ref.watch/read할 수 없음
    // riverpod는 위젯이 완전히 init 된 후에 실행되어야 함
    _user = ref.watch(userModelNotifierProvider);
  }

  // 이게 비동기가 initState로 못들어가니까 따로 빼서 진행
  Future<void> _initializeData() async {
    await _loadNextLottoResult(); // 비동기적으로 LottoResult 로드 후에 아래꺼 진행
    await _loadNextRoundUserGames(); // LottoResult 로드 후 유저 게임 로드
  }

  // 최근(마지막추첨한) 로또리절트를 가져오고, 캐시에 저장된 유저게임리스트 불러온다.
  Future<void> _loadNextLottoResult() async {
    try {
      LottoResult? result = await getCachedLottoResult();
      if (result != null) {
        setState(() {
          _nextLottoResult = result;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed Lotto Result loading.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading Lotto Result: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태를 false로 설정
      });
    }
  }

  // 언제 userGames가 캐시에 저장되는 지 체크해두자.
  // cachedUserGames 에 캐시에 있던 유저게임리스트 불러와서 저장
  Future<void> _loadNextRoundUserGames() async {
    if (_nextLottoResult != null) {
      final userGames =
          await loadUserGames(ref, _nextLottoResult!.roundNumber + 1);
      print('드로우페이제에서의 roundNo+1 = ${_nextLottoResult!.roundNumber + 1}');
      setState(() {
        loadedUserGames = userGames;
      });
    }
  }

  //아래꺼가 원조. camera 다트파일 지우면 아래꺼 복구
  Future<void> _scanLotteryTicket(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (context.mounted) {
        await processMyImage(
          image,
          context,
          ref,
          onSaveComplete: () async {
            await _loadNextRoundUserGames();
            setState(() {}); // UI 갱신을 위해
          },
        );
      }
    }
  }




  void _showGameDelete(BuildContext context, UserGame game, int index) {
    final sortedNumbers = game.selectedDrwNos.toList()..sort();

    showModalBottomSheet(
      backgroundColor: backGroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 3,
                width: 60,
                color: primaryBlack,
              ),
              const MySizedBox(height: 32),
              const Text('선택한 게임을 삭제하시겠습니까?'),
              const MySizedBox(height: 16),

              // 선택한 게임 정보 표시
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: sortedNumbers.map((number) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Text(
                        number.toString(),
                        style: ballTextStyleDrawPage,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              // 취소 및 삭제 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // 팝업 닫기
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(width: 1.5, color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 100,
                        height: 50.0,
                        child: const Center(
                            child: Text(
                          '취소',
                          style: btnTextStyle,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final BuildContext currentContext = context;

                        // Firebase에서 게임 삭제
                        final userGameCollection = FirebaseFirestore.instance
                            .collection('users')
                            .doc(_user!.uid) // 현재 사용자의 uid로 참조
                            .collection('userGames');

                        final String gameId = loadedUserGames[index]
                            .gameId; // 삭제할 게임의 gameId 가져오기

                        try {
                          // Firestore에서 gameId를 이용하여 문서 삭제
                          await userGameCollection.doc(gameId).delete();

                          // UI에서 삭제 및 캐시 업데이트
                          setState(() {
                            loadedUserGames.removeAt(index); // UI에서 해당 게임 삭제
                          });

                          // 지우고 난 유저게임리스트를 캐시에 저장
                          await saveGamesToCache(
                              ref, loadedUserGames, _nextLottoResult!);

                          // 저장이 완료되면 팝업 닫기
                          if (currentContext.mounted) {
                            Navigator.pop(currentContext);
                          }
                        } catch (e) {
                          print('Error deleting game: $e');
                          // 오류 처리 (예: 스낵바를 표시)
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(width: 1.5, color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 100,
                        height: 50.0,
                        child: const Center(
                            child: Text(
                          '삭제',
                          style: btnTextStyle,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelNotifierProvider);
    final user = ref.watch(authServiceProvider);
    final userModelClass = ref.watch(userModelNotifierProvider.notifier);

    int maxGames = userModel!.maxGames;
    bool isMaxGamesReached = loadedUserGames.length >= maxGames;

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Text('추첨하기', style: appBarTitleTextStyleWithStroke),
                Text('추첨하기', style: appBarTitleTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: maxGames - loadedUserGames.length >= 5
                ? () => _scanLotteryTicket(context)
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            '등록 가능 게임이 5게임 이상이어야\nAI OCR기능을 사용할 수 있습니다.\n롱탭으로 게임을 삭제할 수 있습니다.'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: '확인',
                          onPressed: () {
                            // 액션 버튼을 눌렀을 때의 동작
                          },
                        ),
                        backgroundColor: Colors.black87,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
            child: Image.asset('assets/images/draw_camera.png', width: 32),
          ),
          const SizedBox(width: 16)
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Text('') // 로딩 인디케이터 표시
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!)) // 에러 메시지 표시
              : Column(
                  children: [
                    if (_nextLottoResult != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${_nextLottoResult!.roundNumber + 1}회',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '  ${loadedUserGames.length}/$maxGames',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '추첨일 : ${_nextLottoResult!.nextWeekDrawDate}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: loadedUserGames.isNotEmpty
                          ? ListView.builder(
                              itemCount: loadedUserGames.length,
                              itemBuilder: (context, index) {
                                final game = loadedUserGames[index];
                                final sortedNumbers =
                                    game.selectedDrwNos.toList()..sort();
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      _showGameDelete(context, game,
                                          index); // 팝업을 띄우는 함수 호출
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1, color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: sortedNumbers.map((number) {
                                          return CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.grey,
                                            child: Text(
                                              number.toString(),
                                              style: ballTextStyleDrawPage,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const NoLottoNoti(),
                    ),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: isMaxGamesReached
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          '회차별 5게임 초과 도전은 업그레이드를 통해 가능하며, 업그레이드 시 알찬 혜택이 주렁주렁 딸려옵니다'),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: '확인',
                        onPressed: () {
                          // 액션 버튼을 눌렀을 때의 동작
                        },
                      ),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              : () async {
                  if (_nextLottoResult != null && user != null) {
                    final UserGame? newGame = await Navigator.push<UserGame>(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            NumberSelectionScreen(
                          playerUid: user.uid,
                          roundNo: _nextLottoResult!.roundNumber + 1,
                        ),
                        transitionDuration: Duration.zero, // 애니메이션 지속 시간 0
                        reverseTransitionDuration:
                            Duration.zero, // 뒤로 가기 애니메이션도 0
                      ),
                    );

                    if (newGame != null) {
                      setState(() {
                        // 캐시에 있던 게임리스트 불러와서 추가
                        loadedUserGames.add(newGame);
                      });
                      // 그리고 다시 캐시에 추가
                      await saveGamesToCache(
                          ref, loadedUserGames, _nextLottoResult!);
                    }
                  } else {
                    print('Lotto result or user is not available');
                  }
                },
          child: MyBtnContainer(
            color: isMaxGamesReached ? Colors.grey : specialBlue,
            child: const Center(
              child: Text(
                '뽑기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
