import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<void> deleteAppCache() async {
  // 기본 캐시 매니저의 모든 캐시를 삭제
  await DefaultCacheManager().emptyCache();
  print("All cache cleared successfully");
}