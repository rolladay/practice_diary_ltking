import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';

import '../constants/color_constants.dart';
import 'my_btn_container.dart';

class AIDrawBottomSheet extends StatefulWidget {
  const AIDrawBottomSheet({super.key});

  @override
  AIDrawBottomSheetState createState() => AIDrawBottomSheetState();
}

class AIDrawBottomSheetState extends State<AIDrawBottomSheet> {
  int numberOfGames = 1;
  int oddEvenRatio = 3;
  int highLowRatio = 3;
  int sumRange = 2;
  int luckyNumbersCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: 60,
            color: primaryBlack,
          ),
          const MySizedBox(height: 40),
          _buildNumberOfGamesSlider(),
          const MySizedBox(height: 20),
          _buildRatioSelector("홀짝비", oddEvenRatio,
              (value) => setState(() => oddEvenRatio = value)),
          const MySizedBox(height: 20),
          _buildRatioSelector("저고비", highLowRatio,
              (value) => setState(() => highLowRatio = value)),
          const MySizedBox(height: 20),
          _buildSumRangeSelector(),

          const MySizedBox(height: 40),
          _buildSummary(),
          const MySizedBox(height: 20),
          // _buildLuckyNumbersSelector(),
          GestureDetector(
            onTap: _generateNumbers,
            child: MyBtnContainer(
              color: specialBlue,
              child: const Center(
                  child: Text(
                'AI 추첨번호 생성',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberOfGamesSlider() {
    return Row(
      children: [
        const SizedBox(width: 64, child: Text("게임수")),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 4.0),
            ),
            child: Slider(
              inactiveColor: Colors.grey,
              activeColor: specialBlue,
              value: numberOfGames.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: numberOfGames.toString(),
              onChanged: (value) =>
                  setState(() => numberOfGames = value.round()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatioSelector(String title, int value, Function(int) onChanged) {
    return Row(
      children: [
        SizedBox(width: 64, child: Text(title)),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 4.0),
            ),
            child: Slider(
              inactiveColor: Colors.grey,
              activeColor: specialBlue,
              value: value.toDouble(),
              min: 0,
              max: 6,
              divisions: 6,
              label: "${6 - value}:$value",
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSumRangeSelector() {
    final List<String> rangeLabels = [
      "21-100",
      "101-120",
      "121-140",
      "141-160",
      "161-180",
      "181-255"
    ];

    return Row(
      children: [
        const SizedBox(width: 64, child: Text("번호합")),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 4.0),

            ),
            child: Slider(
              inactiveColor: Colors.grey,
              activeColor: specialBlue,
              value: sumRange.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: rangeLabels[sumRange],
              onChanged: (newValue) =>
                  setState(() => sumRange = newValue.round()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyNumbersSelector() {
    return Column(
      children: [
        Text("행운 번호 포함 개수: $luckyNumbersCount"),
        Slider(
          value: luckyNumbersCount.toDouble(),
          min: 0,
          max: 6,
          divisions: 6,
          label: luckyNumbersCount.toString(),
          onChanged: (newValue) =>
              setState(() => luckyNumbersCount = newValue.round()),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    final List<String> rangeLabels = [
      "21-100", "101-120", "121-140", "141-160", "161-180", "181-255"
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 15, color: Colors.black54),
            children: [
              const TextSpan(text: '홀짝비율 '),
              TextSpan(
                text: '${6-oddEvenRatio}:$oddEvenRatio',
                style: TextStyle(color: specialBlue, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ', 저고비율 '),
              TextSpan(
                text: '${6-highLowRatio}:$highLowRatio',
                style: TextStyle(color: specialBlue, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ', 번호합 '),
              TextSpan(
                text: rangeLabels[sumRange],
                style: TextStyle(color: specialBlue, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: '\n의 게임을 '),
              TextSpan(
                text: '$numberOfGames',
                style: TextStyle(color: specialBlue, fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: '개 생성합니다.'),
              const TextSpan(text: '\n※조합요건에 따라 근사치를 제공할 수 있습니다.', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
        )
      ),
    );
  }

  List<List<int>> generateLottoNumbers({
    required int numberOfGames,
    required int oddEvenRatio,
    required int highLowRatio,
    required int sumRange,
  }) {
    List<List<int>> generatedNumbers = [];
    Random random = Random();

    // 합계 범위 설정
    List<List<int>> sumRanges = [
      [21, 100],
      [101, 120],
      [121, 140],
      [141, 160],
      [161, 180],
      [181, 255]
    ];
    List<int> selectedSumRange = sumRanges[sumRange];

    for (int game = 0; game < numberOfGames; game++) {
      List<int> numbers = [];
      int oddCount = 6 - oddEvenRatio;
      int lowCount = 6 - highLowRatio;
      int sum = 0;
      Set<int> availableNumbers = Set.from(List.generate(45, (index) => index + 1));

      for (int i = 0; i < 6; i++) {
        int newNumber;
        int remainingNumbers = 6 - i;
        int minSum = selectedSumRange[0] - sum;
        int maxSum = selectedSumRange[1] - sum;

        // 조건에 맞는 숫자 범위 결정
        Set<int> validNumbers = availableNumbers.where((n) {
          bool isValid = true;
          if (oddCount > 0) isValid &= n % 2 != 0;
          if (oddCount == 0) isValid &= n % 2 == 0;
          if (lowCount > 0) isValid &= n <= 23;
          if (lowCount == 0) isValid &= n > 23;
          isValid &= n >= (minSum - 45 * (remainingNumbers - 1)).clamp(1, 45);
          isValid &= n <= (maxSum - (remainingNumbers - 1)).clamp(1, 45);
          return isValid;
        }).toSet();

        // 조건에 맞는 숫자가 없으면 제약 조건 완화
        if (validNumbers.isEmpty) {
          validNumbers = availableNumbers;
        }

        newNumber = validNumbers.elementAt(random.nextInt(validNumbers.length));

        numbers.add(newNumber);
        availableNumbers.remove(newNumber);
        sum += newNumber;
        if (newNumber % 2 != 0) oddCount--;
        if (newNumber <= 23) lowCount--;
      }

      numbers.sort();
      generatedNumbers.add(numbers);
    }

    return generatedNumbers;
  }







  void _generateNumbers() {
    // 여기에 번호 생성 로직을 구현합니다.
    // 설정된 값들(numberOfGames, oddEvenRatio, highLowRatio, sumRange, luckyNumbersCount)을 사용하여
    // 로또 번호를 생성하고 결과를 표시합니다.
    List<List<int>> results = generateLottoNumbers(
      numberOfGames: numberOfGames,
      oddEvenRatio: oddEvenRatio,
      highLowRatio: highLowRatio,
      sumRange: sumRange,
    );

    // 결과 처리 (예: 상태 업데이트 또는 결과 표시)
    print(results);
  }
}
