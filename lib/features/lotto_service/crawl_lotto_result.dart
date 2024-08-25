import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../../models/lotto_result_model/lotto_result.dart';
import '../isar_db/isar_service.dart';



// 현재시간을 집어넣어 다음 당첨결과발표일을 변수에 저장한다.마지막 업데이트 시간을 확인해서
// 만약 지금시간이 다음당첨일을 지났고, 마지막 업데이트시간이 당첨일 전이라면
// 웹크롤링을해서 새로운 LottoResult객체에 저장한다. Isar의 마지막 로또객체와 비교해서 뉴리절크가 더 최근이면
// Isar에도 뉴리절트 저장하고, 캐시에도 저장한다.(덮어씀)
// 그게 아니고 아직 웹크롤링 할떄 안된경우에는 밑에가 실행되는데
Future<LottoResult> getCachedOrFetchLottoResult() async {
  //디폴트캐시매니저 선언
  final cacheManager = DefaultCacheManager();
  //Isar서비스 선언
  final isarService = IsarService();

  try {
    final now = DateTime.now();
    final nextDrawTime = getNextDrawTime(now);


    // 마지막 업데이트 시간 확인
    final lastUpdateFileInfo = await cacheManager.getFileFromCache('last_update_time');
    DateTime lastUpdateTime = lastUpdateFileInfo != null
        ? DateTime.parse(await lastUpdateFileInfo.file.readAsString())
        : DateTime(1970);
    print(lastUpdateTime);
    print(nextDrawTime);

    //최근회차일자를 지났고, 마지막 웹http실행날짜가 이 회차일자보다 전이면 실행, 즉 웹크롤링실행하는 경우
    if (now.isAfter(nextDrawTime) && lastUpdateTime.isBefore(nextDrawTime)) {
      // 새로운 결과를 가져와야 하는 경우 newLottoResult는 Future<LottoResult>를 담고있다.
      final newLottoResult = await fetchLottoResult();

      // 기존 데이터와 비교
      final lastResult = await isarService.getLatestLottoResult();

      if (lastResult == null || newLottoResult.roundNumber > lastResult.roundNumber) {
        // 새로운 결과가 있을 경우 업데이트
        await isarService.saveLottoResult(newLottoResult);

        // 캐시에 저장 - 기존 것 덮어쓴다.
        await cacheManager.putFile('lotto_result', utf8.encode(jsonEncode(newLottoResult.toJson())));

        // 마지막 업데이트 시간 캐시에 저장
        await cacheManager.putFile(
          'last_update_time',//이게 캐시의 파일 키, 저위에도 있음(getFileFromCache)
          utf8.encode(now.toIso8601String()),
          maxAge: const Duration(days: 365),
        );

        return newLottoResult;
      }
      //Isar 에 있는 가장 최근 LottoResult
      return lastResult;
    }

    // 캐시된 데이터 반환
    final fileInfo = await cacheManager.getFileFromCache('lotto_result');
    if (fileInfo != null) {
      final jsonString = utf8.decode(await fileInfo.file.readAsBytes());
      return LottoResult.fromJson(jsonDecode(jsonString));
    }

    // 캐시된 데이터가 없는 경우 IsarDB에서 가져오기
    return await isarService.getLatestLottoResult() ?? LottoResult.empty();
  } catch (e) {
    print('Error in getCachedOrFetchLottoResult: $e');
    // 에러 발생 시 IsarDB에서 가져오기
    return await isarService.getLatestLottoResult() ?? LottoResult.empty();
  }
}


// LottoResult의 Future를 반환하는것 까지만 얘의 임무
Future<LottoResult> fetchLottoResult() async {
  final response = await http.get(Uri.parse(
      'https://dhlottery.co.kr/gameResult.do?method=byWin&wiselog=C_A_1_1'));

  if (response.statusCode == 200) {
    var document = parse(response.body);

    // 회차 정보 크롤링
    final strongElement = document.querySelector('.win_result strong');
    final strongText = strongElement?.text ?? 'No data';
    final drawNumber = int.parse(RegExp(r'\d+').firstMatch(strongText)?.group(0) ?? '0');

    // 추첨일자
    final dateElement = document.querySelector('p.desc');
    final drawDate = dateElement?.text ?? '';
    final numbers = RegExp(r'\d+')
        .allMatches(drawDate)
        .map((match) => match.group(0)!)
        .toList();

    if (numbers.length >= 3) {
      final year = int.parse(numbers[0]);
      final month = int.parse(numbers[1]);
      final day = int.parse(numbers[2]);

      final formattedDrawDate = DateTime(year, month, day);

      // drawDate출력시 저 메소드써서...
      //void main() async {
      //   final lottoResult = await fetchLottoResult();
      //
      //   print('Round Number: ${lottoResult.roundNumber}');
      //   print('Draw Date: ${lottoResult.formattedDrawDate}'); // "2024-08-23" 형식으로 출력됨
      // }


      // 당첨번호 크롤링
      final winningNumbers = document
          .querySelectorAll('.num.win span')
          .map((element) => int.parse(element.text))
          .toList();

      // 보너스 번호 크롤링
      final bonusNumber = int.parse(document.querySelector('.num.bonus span')?.text ?? '0');

      // 당첨금액 크롤링
      final tarElements = document.querySelectorAll('.tbl_data tbody tr:first-child td.tar');
      final firstPrizeAmount = tarElements.length >= 2 ? tarElements[1].text.trim() : 'No data';
      final prizeAmount = firstPrizeAmount.length > 1
          ? firstPrizeAmount.substring(0, firstPrizeAmount.length - 2)
          : firstPrizeAmount;

      return LottoResult(
        roundNumber: drawNumber,
        winningNumbers: winningNumbers,
        bonusNumber: bonusNumber,
        prizeAmounts: prizeAmount,
        drawDate: formattedDrawDate,
      );
    } else {
      throw Exception('Invalid date format');
    }
  } else {
    throw Exception('Failed to load lotto result');
  }
}


//가장 최근의 추첨일자를 가져온다.- 확인완료
DateTime getNextDrawTime(DateTime now) {
  // 이번 주 토요일 20:30
  var drawTime = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday))
      .add(const Duration(days: 6, hours: 20, minutes: 45));

  // 현재 시간이 이번 주 토요일 20:30 이전이라면 지난 주 토요일로 설정
  if (now.isBefore(drawTime)) {
    drawTime = drawTime.subtract(const Duration(days: 7));
  }

  return drawTime;
}