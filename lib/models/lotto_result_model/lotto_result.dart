
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

part 'lotto_result.g.dart';


//isarDB에 저장한 클래스임
@collection
class LottoResult {
  Id id = Isar.autoIncrement; // Isar에서 사용할 고유 ID

  // 회차정보가 유니크해야하며, 이에따라 Isar는 이 유니크 인덱스를 사용하여 객체의 존재 여부를 확인 후 업데이트 수행
  @Index(unique: true)
  final int roundNumber;

  final List<int> winningNumbers;
  final int bonusNumber;
  final String prizeAmounts;
  final DateTime drawDate;

  LottoResult({
    required this.roundNumber,
    required this.winningNumbers,
    required this.bonusNumber,
    required this.prizeAmounts,
    required this.drawDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'drawNumber': roundNumber,
      'winningNumbers': winningNumbers,
      'bonusNumber': bonusNumber,
      'prizeAmounts': prizeAmounts,
      'drawDate': drawDate.toIso8601String(),
    };
  }

  factory LottoResult.fromJson(Map<String, dynamic> json) {
    return LottoResult(
      roundNumber: json['drawNumber'],
      winningNumbers: List<int>.from(json['winningNumbers']),
      bonusNumber: json['bonusNumber'],
      prizeAmounts: json['prizeAmounts'],
      drawDate: DateTime.parse(json['drawDate']),
    );
  }

  factory LottoResult.empty() {
    return LottoResult(
      roundNumber: 0,
      winningNumbers: [],
      bonusNumber: 0,
      prizeAmounts: '0',
      drawDate: DateTime(1970),
    );
  }

  //DateTime 출력시 일정 요건에 맞게 포맷하는 방법
  String get formattedYMDDrawDate => DateFormat('yyyy-MM-dd').format(drawDate);

  String get nextWeekDrawDate {
    final nextWeekDate = drawDate.add(const Duration(days: 7));
    return DateFormat('yyyy-MM-dd').format(nextWeekDate);
  }

}