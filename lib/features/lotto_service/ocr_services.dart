import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:kingoflotto/features/lotto_service/usergame_manager.dart';
import '../../components/my_btn_container.dart';
import '../../components/my_sizedbox.dart';
import '../../constants/color_constants.dart';
import '../../constants/fonts_constants.dart';
import '../../models/user_game_model/user_game.dart';
import '../user_service/user_provider.dart';
import 'lotto_result_manager.dart';

// 여기 지금 함수만있는 dart파일이 있는데, 이걸 OCR Class로 만들어서 프로바이더 ref를 적용할 수 있게 간단히 바꿀 수 있나?

// 사진찍기 버튼 눌러서 실행되는 함수
Future<void> processMyImage(
    XFile image,
    BuildContext context,
    WidgetRef ref,
    {Function? onSaveComplete}
    ) async {
  final inputImage = InputImage.fromFilePath(image.path);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  try {
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);
    print("OCR 인식된 텍스트: ${recognizedText.text}");

    final List<List<int>> extractedNumbers =
    _extractLotteryNumbers(recognizedText.text);
    print('추출된 리스트는: $extractedNumbers');

    if (context.mounted) {
      _showExtractedNumbersModal(
        context,
        extractedNumbers,
        ref,
        onSaveComplete: onSaveComplete,
      );
    }
  } finally {
    textRecognizer.close();
  }
}

// 추출된 번호를 Modal로 보여주는 함수
void _showExtractedNumbersModal(
    BuildContext context, List<List<int>> extractedNumbers, WidgetRef ref, {Function? onSaveComplete}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: backGroundColor, // 배경색 설정
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(8.0), // 모서리 반지름 설정
      ),
    ),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 3,
              width: 60,
              color: primaryBlack,
            ),
          ),
          const MySizedBox(height: 8),
          const Text(
            'AI OCR 추출번호',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const MySizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                  child: Text(
                'OCR 정확도는 번호 왼쪽 [A 자 동]이 잘 찍혀야합니다.\n인쇄품질이 낮은 경우 인식이 바르게 되지 않습니다.',
                style: TextStyle(color: Colors.black54),
              )),
            ),
          ),
          const MySizedBox(height: 16),
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: extractedNumbers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: extractedNumbers[index].map((number) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // primaryBlack으로 변경 가능
                              width: 1.0,
                            ),
                            color: Colors.grey,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              await _onConfirm(context, ref, extractedNumbers);
              if (onSaveComplete != null) {
                onSaveComplete();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyBtnContainer(
                color: specialBlue,
                child: const Center(
                  child: Text(
                    '게임저장',
                    style: btnTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// 로또 번호를 추출하는 함수
List<List<int>> _extractLotteryNumbers(String text) {
  final List<List<int>> result = [];

  // 알파벳 A~E로 시작하는 행을 찾기 위한 정규식 (자동, 수동, 반자동도 포함)
  final RegExp numberRegex = RegExp(
      r'[A-E]\s*(자\s*동|수\s*동|반\s*자동)\s*(\d{2})\s*(\d{2})\s*(\d{2})\s*(\d{2})\s*(\d{2})\s*(\d{2})');

  // 텍스트에서 패턴을 추출
  final matches = numberRegex.allMatches(text);

  // 추출된 각 행에서 숫자 그룹을 얻음
  for (final match in matches) {
    // 모든 그룹을 합친 후 붙어있는 숫자도 처리
    final rawNumbers = match.groups([2, 3, 4, 5, 6, 7]).join('');

    // 번호가 붙어있을 수 있으므로 두 자리씩 분리
    final List<int> numbers = _splitIntoTwoDigits(rawNumbers);

    // 6개의 유효한 숫자가 있는지 확인
    if (numbers.length == 6 && numbers.every((n) => n >= 1 && n <= 45)) {
      result.add(numbers);
    }
  }

  return result;
}

// 문자열을 2자리씩 나누는 함수 (붙어있는 숫자를 2자리씩 분리)
List<int> _splitIntoTwoDigits(String input) {
  final List<int> result = [];
  for (int i = 0; i < input.length; i += 2) {
    // 범위를 넘지 않도록 처리
    if (i + 2 <= input.length) {
      result.add(int.parse(input.substring(i, i + 2)));
    }
  }
  return result;
}



// Future<void> saveScannedNumber(WidgetRef ref, LottoResult lottoResult, List<UserGame> extractedGames,) async {
//   final user = ref.read(userModelNotifierProvider);
//   final userModelClass = ref.read(userModelNotifierProvider.notifier);
//
//   //캐시에 먼저 저장하고...
//   saveGamesToCache(ref, extractedGames, lottoResult);
//
//   final userGameCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .collection('userGames');
//
//   // 라운드넘버는 +1되야 할 것 같은데 나중에 체크
//   QuerySnapshot existingGames = await userGameCollection
//       .where('roundNo', isEqualTo: lottoResult.roundNumber)
//       .get();
//
//   final gameCount = existingGames.size + 1;
//   // 현재 타임스탬프 생성
//   final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//
//   // gameId에 타임스탬프 추가
//   final gameId =
//       '${user.uid}_${lottoResult.roundNumber}_${gameCount.toString().padLeft(3, '0')}_$timestamp';
//
//   UserGame userGame = UserGame(
//     gameId: gameId,
//     roundNo: lottoResult.roundNumber,
//     selectedDrwNos: selectedNos,
//     playerUid: user.uid,
//   );
//
//   await ref
//       .read(userModelNotifierProvider.notifier)
//       .addGameToUser(userGame, user.uid);
// }

// Future<void> saveScannedNumber(WidgetRef ref, List<List<int>> extractedNumbers) async {
//   final user = ref.read(userModelNotifierProvider);
//   final userModelClass = ref.read(userModelNotifierProvider.notifier);
//
//   // 현재 로또 결과 가져오기
//   final lottoResult = await getCachedLottoResult();
//   if (lottoResult == null) {
//     print('로또 결과 또는 사용자 정보를 가져올 수 없습니다.');
//     return;
//   }
//
//   final userGameCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .collection('userGames');
//
//   QuerySnapshot existingGames = await userGameCollection
//       .where('roundNo', isEqualTo: lottoResult.roundNumber+1)
//       .get();
//
//   final gameCount = existingGames.size + 1;
//   // 기존 캐시에서 userGames 로드, +1 되어있는 게임을 불러온거임.(수정완료)
//   List<UserGame> existingUserGames = await loadUserGamesFromCache(ref, lottoResult.roundNumber);
//
//   // 새로운 게임 생성 및 기존 리스트에 추가
//   List<UserGame> newUserGames = extractedNumbers.map((numbers) {
//     final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     final gameId = '${user.uid}_${lottoResult.roundNumber+1}_${gameCount.toString().padLeft(3, '0')}_$timestamp';
//
//     return UserGame(
//       gameId: gameId,
//       roundNo: lottoResult.roundNumber+1,
//       selectedDrwNos: numbers,
//       playerUid: user.uid,
//     );
//   }).toList();
//   print(newUserGames);
//
//
//   existingUserGames.addAll(newUserGames);
//   // 캐시에 저장 (기존 게임 + 새 게임)
//   await saveGamesToCache(ref, existingUserGames, lottoResult);
//   // Firebase에 새 게임만 저장
//   await userModelClass.addGamesToUser(newUserGames, user.uid);
// }


Future<void> saveScannedNumber(WidgetRef ref, List<List<int>> extractedNumbers) async {
  final user = ref.read(userModelNotifierProvider);
  final userModelClass = ref.read(userModelNotifierProvider.notifier);

  // 현재 로또 결과 가져오기
  final lottoResult = await getCachedLottoResult();
  if (lottoResult == null) {
    print('로또 결과 또는 사용자 정보를 가져올 수 없습니다.');
    return;
  }

  final userGameCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('userGames');

  QuerySnapshot existingGames = await userGameCollection
      .where('roundNo', isEqualTo: lottoResult.roundNumber+1)
      .get();

  int currentGameCount = existingGames.size;
  // 기존 캐시에서 userGames 로드, +1 되어있는 게임을 불러온거임.(수정완료)
  List<UserGame> existingUserGames = await loadUserGamesFromCache(ref, lottoResult.roundNumber);

  // 새로운 게임 생성 및 기존 리스트에 추가
  List<UserGame> newUserGames = [];

  for (var numbers in extractedNumbers) {
    currentGameCount++;
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final gameId = '${user.uid}_${lottoResult.roundNumber+1}_${currentGameCount.toString().padLeft(3, '0')}_$timestamp';

    newUserGames.add(UserGame(
      gameId: gameId,
      roundNo: lottoResult.roundNumber+1,
      selectedDrwNos: numbers,
      playerUid: user.uid,
    ));

    // 선택적: 타임스탬프 중복 방지를 위한 짧은 지연
    await Future.delayed(const Duration(microseconds: 1));
  }

  print(newUserGames);

  existingUserGames.addAll(newUserGames);
  // 캐시에 저장 (기존 게임 + 새 게임)
  await saveGamesToCache(ref, existingUserGames, lottoResult);
  // Firebase에 새 게임만 저장
  await userModelClass.addGamesToUser(newUserGames, user.uid);
}


Future<List<UserGame>> loadUserGamesFromCache(WidgetRef ref, int roundNumber) async {
  final cacheManager = DefaultCacheManager();
  final user = ref.read(userModelNotifierProvider);
  if (user != null) {
    final cacheKey = 'user_game_${user.uid}_${roundNumber+1}';
    try {
      final fileInfo = await cacheManager.getFileFromCache(cacheKey);
      if (fileInfo != null) {
        final jsonString = await fileInfo.file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => UserGame.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading games from cache: $e');
    }
  }
  return [];
}



Future<void> _onConfirm(BuildContext context, WidgetRef ref, List<List<int>> extractedNumbers) async {
  await saveScannedNumber(ref, extractedNumbers);
  if (context.mounted) {
    Navigator.of(context).pop(); // Modal을 닫음
  }
}



