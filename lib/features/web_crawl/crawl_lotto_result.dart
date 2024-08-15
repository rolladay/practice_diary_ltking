import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../../models/lotto_result_model/lotto_result.dart';

Future<LottoResult> getCachedOrFetchLottoResult() async {
  final cacheManager = DefaultCacheManager();
  try {
    final fileInfo = await cacheManager.getFileFromCache('lotto_result');

    if (fileInfo != null) {
      // 캐시된 데이터가 있을 경우
      final jsonString = utf8.decode(await fileInfo.file.readAsBytes());
      print('Cached data: $jsonString');
      final jsonMap = jsonDecode(jsonString);
      return LottoResult.fromJson(jsonMap);
    } else {
      // 캐시된 데이터가 없을 경우, 데이터를 가져와서 캐시에 저장
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

        DateTime formattedDrawDate;

        if (numbers.length >= 3) {
          final year = int.parse(numbers[0]);
          final month = int.parse(numbers[1]);
          final day = int.parse(numbers[2]);

          formattedDrawDate = DateUtils.dateOnly(DateTime(year, month, day));

          // 당첨번호 크롤링
          final winningNumbers = document
              .querySelectorAll('.num.win span')
              .map((element) => int.parse(element.text))
              .toList();

          // 보너스 번호 크롤링
          final bonusNumber =
          int.parse(document.querySelector('.num.bonus span')?.text ?? '0');

          // 당첨금액 크롤링
          final tarElements = document.querySelectorAll('.tbl_data tbody tr:first-child td.tar');

          // 두 번째 td.tar 요소의 텍스트 가져오기
          final firstPrizeAmount = tarElements.length >= 2 ? tarElements[1].text.trim() : 'No data';

          // 마지막 글자 제거
          final prizeAmount = firstPrizeAmount.length > 1
              ? firstPrizeAmount.substring(0, firstPrizeAmount.length - 2)
              : firstPrizeAmount;

          final lottoResult = LottoResult(
            drawNumber: drawNumber,
            winningNumbers: winningNumbers,
            bonusNumber: bonusNumber,
            prizeAmounts: prizeAmount,
            drawDate: formattedDrawDate,
          );

          // 캐시에 저장
          final jsonString = jsonEncode(lottoResult.toJson());
          try {
            await cacheManager.putFile('lotto_result', utf8.encode(jsonString));
            print('Cache file saved successfully');
          } catch (e) {
            print('Error saving cache file: $e');
          }

          return lottoResult;
        } else {
          throw Exception('Invalid date format');
        }
      } else {
        throw Exception('Failed to load lotto result');
      }
    }
  } catch (e) {
    print('Error in getCachedOrFetchLottoResult: $e');
    rethrow;
  }
}


