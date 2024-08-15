
class LottoResult {

  final int drawNumber;
  final List<int> winningNumbers;
  final int bonusNumber;
  final String prizeAmounts;
  final DateTime drawDate;

  LottoResult({

    required this.drawNumber,
    required this.winningNumbers,
    required this.bonusNumber,
    required this.prizeAmounts,
    required this.drawDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'drawNumber': drawNumber,
      'winningNumbers': winningNumbers,
      'bonusNumber': bonusNumber,
      'prizeAmounts': prizeAmounts,
      'drawDate': drawDate.toIso8601String(),
    };
  }

  factory LottoResult.fromJson(Map<String, dynamic> json) {
    return LottoResult(
      drawNumber: json['drawNumber'],
      winningNumbers: List<int>.from(json['winningNumbers']),
      bonusNumber: json['bonusNumber'],
      prizeAmounts: json['prizeAmounts'],
      drawDate: DateTime.parse(json['drawDate']),
    );
  }
}