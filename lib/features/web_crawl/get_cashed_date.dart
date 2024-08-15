import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../models/lotto_result_model/lotto_result.dart';

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