import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/lotto_result_model/lotto_result.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  factory IsarService() => _instance;
  IsarService._internal();

  late Future<Isar> db;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    db = Isar.open(
      [LottoResultSchema],
      directory: dir.path,
    );
  }

  // 로또 결과 저장
  Future<void> saveLottoResult(LottoResult result) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.lottoResults.put(result);
    });
  }

  // 특정 회차의 로또 결과 가져오기
  Future<LottoResult?> getLottoResult(int roundNumber) async {
    final isar = await db;
    return await isar.lottoResults
        .filter()
        .roundNumberEqualTo(roundNumber)
        .findFirst();
  }

  // 모든 로또 결과 가져오기
  Future<List<LottoResult>> getAllLottoResults() async {
    final isar = await db;
    return await isar.lottoResults.where().findAll();
  }

  // 가장 최근 로또 결과 가져오기
  Future<LottoResult?> getLatestLottoResult() async {
    final isar = await db;
    return await isar.lottoResults
        .where()
        .sortByRoundNumberDesc()
        .findFirst();
  }

  // 로또 결과 삭제
  Future<bool> deleteLottoResult(int roundNumber) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      return await isar.lottoResults
          .filter()
          .roundNumberEqualTo(roundNumber)
          .deleteFirst();
    });
  }
}