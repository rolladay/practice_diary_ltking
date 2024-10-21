import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../models/lotto_result_model/lotto_result.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../isar_db/isar_service.dart';


// 현재시간을 집어넣어 다음 당첨결과발표일을 변수에 저장한다.마지막 업데이트 시간을 확인해서
// 만약 지금시간이 다음당첨일을 지났고, 마지막 업데이트시간이 당첨일 전이라면
// 웹크롤링을해서 새로운 LottoResult객체에 저장한다. Isar의 마지막 로또객체와 비교해서 뉴리절트가 더 최근이면
// Isar에도 뉴리절트 저장하고, 캐시에도 저장한다.(덮어씀)
// 그게 아니고 아직 웹크롤링 할떄 안된경우에는 밑에가 실행되는데
// 가끔 지웠다 깔면 로또 정보 못불러올 때가 있는데... 그건 crawl링 값이 삑사리 나면 그러한 것임

Future<LottoResult> getCachedOrFetchLottoResult() async {
  final cacheManager = DefaultCacheManager();
  final isarService = IsarService();

  try {
    final now = DateTime.now();
    // 저번주토요일, 또는 이번주 토요일을 반환한다.
    final nextDrawTime = getNextDrawTime(now);

    // 마지막 업데이트 시간 확인해서 마지막업데이트시간이 있다면
    // DateTime.parse() 메서드를 사용하여 문자열로 읽어온 데이터를 다시 DateTime 객체로 변환 하는 과정 참고
    final lastUpdateFileInfo = await cacheManager.getFileFromCache('last_update_time');
    DateTime lastUpdateTime = lastUpdateFileInfo != null
        ? DateTime.parse(await lastUpdateFileInfo.file.readAsString())
        : DateTime(1970);

    // 최근회차일자를 지났고, 마지막 웹http실행날짜가 이 회차일자보다 전이면 실행, 즉 웹크롤링실행하는 경우
    // 페키(클로링)한 로또리절트를 이사르에 저장하고, 캐시매니저에도 저장.(로또리절트, 라스트업데이트타임)
    if (now.isAfter(nextDrawTime) && lastUpdateTime.isBefore(nextDrawTime)) {
      final newLottoResult = await fetchLottoResult();
      final lastResult = await isarService.getLatestLottoResult();

      // 이게 안되가지고 새로운 로또리절트 저장안되고 DrawPage도 에러인듯 - 캐시때문에 (지웠다 까는건 됨)
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
      //페치할 필요없는 상황일 결루에는 Isar 에 있는 가장 최근 LottoResult 그대로 보여줌
      return lastResult;
    }
    // if문이 안도는 경우에는 캐시된 데이터 반환 - 처음 접속유저,
    final cachedResult = await getCachedLottoResult();
    if (cachedResult != null) {
      return cachedResult;
    }
    // 캐시된 데이터가 없는 경우 IsarDB에서 가져오기, isar에는 언제 저장되냐면 위에서 저장됨
    return await isarService.getLatestLottoResult() ?? LottoResult.empty();
  } catch (e) {
    print('Error in getCachedOrFetchLottoResult: $e');
    // 에러 발생 시 IsarDB에서 가져오기
    return await isarService.getLatestLottoResult() ?? LottoResult.empty();
  }
}


//가장 최근의 추첨일자를 가져온다.- 확인완료
DateTime getNextDrawTime(DateTime now) {
  // 이번 주 토요일 20:30
  var drawTime = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday))
      .add(const Duration(days: 6, hours: 20, minutes: 45));
  // 현재 시간이 이번 주 토요일 20:30 이전이라면 drawTime을 7일전으로 설정(즉 아직 페치할떄 안됬다는 뜻)
  if (now.isBefore(drawTime)) {
    drawTime = drawTime.subtract(const Duration(days: 7));
  }
  return drawTime;
}


// 캐시에 저장된 로또리절트 가져오는 함수 이건 무조건 있을 수 밖에 없음. isar에서 가져와도 되긴 하지만...캐시가 나음
Future<LottoResult?> getCachedLottoResult() async {
  final cacheManager = DefaultCacheManager();
  try {
    final fileInfo = await cacheManager.getFileFromCache('lotto_result');
    if (fileInfo != null) {
      final jsonString = await fileInfo.file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      return LottoResult.fromJson(jsonMap);
    }
  } catch (e) {
    print('Error reading cached lotto result: $e');
  }
  return null;
}




// 이 파일이 혹시라도 로또 홈페이지 html구조 바뀌면 겁나 수정해야 할 부분 ㄷㄷㄷ
// 제발 바뀌지 마라 이것들아 ㅠㅠ
Future<LottoResult> fetchLottoResult() async {
  final response = await http.get(Uri.parse(
      'https://dhlottery.co.kr/gameResult.do?method=byWin&wiselog=C_A_1_1'));

  if (response.statusCode == 200) {
    var document = parse(response.body);

    // 회차 정보 크롤링
    final strongElement = document.querySelector('.win_result strong');
    final strongText = strongElement?.text ?? 'No data';
    final drawNumber =
        int.parse(RegExp(r'\d+').firstMatch(strongText)?.group(0) ?? '0');

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

      // 당첨번호 크롤링
      final winningNumbers = document
          .querySelectorAll('.num.win span')
          .map((element) => int.parse(element.text))
          .toList();

      // 보너스 번호 크롤링
      final bonusNumber =
          int.parse(document.querySelector('.num.bonus span')?.text ?? '0');

      // 1등 당첨금액 크롤링
      final tarElements =
          document.querySelectorAll('.tbl_data tbody tr:first-child td.tar');
      final firstPrizeAmount =
          tarElements.length >= 2 ? tarElements[1].text.trim() : 'No data';
      final prizeAmount = firstPrizeAmount.length > 1
          ? firstPrizeAmount.substring(0, firstPrizeAmount.length - 2)
          : firstPrizeAmount;

      // 2등 당첨금액 크롤링
      String prizeAmount2 = 'No data';
      final trElements = document.querySelectorAll('.tbl_data tbody tr');
      if (trElements.length > 1) {
        final tarElements2 = trElements[1].querySelectorAll('td.tar');
        final secondPrizeAmount =
            tarElements2.length >= 2 ? tarElements2[1].text.trim() : 'No data';
        prizeAmount2 = secondPrizeAmount.length > 1
            ? secondPrizeAmount.substring(0, secondPrizeAmount.length - 2)
            : secondPrizeAmount;
      } else {
        prizeAmount2 = 'No data';
      }

      // 3등 당첨금액 크롤링 (업데이트된 선택자 사용)
      String prizeAmount3 = 'No data';
      if (trElements.length > 2) { // 3등 데이터이므로 2번째 인덱스 사용
        final tarElements3 = trElements[2].querySelectorAll('td.tar');
        if (tarElements3.length >= 2) {
          final thirdPrizeAmount = tarElements3[1].text.trim();
          prizeAmount3 = thirdPrizeAmount.length > 1
              ? thirdPrizeAmount.substring(0, thirdPrizeAmount.length - 2)
              : thirdPrizeAmount;
        } else {
          prizeAmount3 = 'No data';
        }
      }

      // 1등당첨자 크롤링
      String winnerNumber = '0';
      // 테이블의 모든 행을 선택
      final rows = document.querySelectorAll('table.tbl_data tbody tr');
      // 첫 번째 행(인덱스 0)이 1등 정보를 담고 있다고 가정
      if (rows.isNotEmpty) {
        final firstRow = rows[0];
        final cells = firstRow.querySelectorAll('td');
        for (var i = 0; i < cells.length; i++) {}
        if (cells.length >= 3) {
          winnerNumber = cells[2].text.trim();
        }
      }

      return LottoResult(
        winners: winnerNumber,
        roundNumber: drawNumber,
        winningNumbers: winningNumbers,
        bonusNumber: bonusNumber,
        prizeAmounts: prizeAmount,
        // 여기 2등 3등 상금 컴컴
        prizeAmounts2: prizeAmount2,
        prizeAmounts3: prizeAmount3,
        drawDate: formattedDrawDate,
      );
    } else {
      throw Exception('Invalid date format');
    }
  } else {
    throw Exception('페치로또리절트 함수 결과 예외 Failed to load lotto result');
  }
}
