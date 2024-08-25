import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../models/lotto_result_model/lotto_result.dart';


// 캐시에 있는(키 : 'lotto_result') 로또 결과 다 반환 (최근거 아님)
Future<LottoResult?> getCachedLottoResult() async {
  final cacheManager = DefaultCacheManager();
  try {
    final fileInfo = await cacheManager.getFileFromCache('lotto_result');
    if (fileInfo != null) {
      final jsonString = await fileInfo.file.readAsString();
      final jsonMap = jsonDecode(jsonString);
      // 이상하네..이걸 가져와서 드로우페이지의 _nextLottoResult에 저장하는데 하나만 와야되는데...
      print('겟캐시드로또리절트 반환갑 : $jsonMap');
      return LottoResult.fromJson(jsonMap);
    }
  } catch (e) {
    print('Error reading cached lotto result: $e');
  }
  return null;
}