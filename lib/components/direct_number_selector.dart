import 'package:flutter/material.dart';

class DirectNumberSelector extends StatefulWidget {
  const DirectNumberSelector({super.key});

  @override
  DirectNumberSelectorState createState() => DirectNumberSelectorState();
}

class DirectNumberSelectorState extends State<DirectNumberSelector> {
  List<int> selectedNumbers = [];

  void toggleNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < 6) {
        selectedNumbers.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('번호 선택'),
      content: Wrap(
        spacing: 8.0,
        children: List.generate(45, (index) {
          int number = index + 1;
          return ChoiceChip(
            label: Text(number.toString()),
            selected: selectedNumbers.contains(number),
            onSelected: (_) => toggleNumber(number),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedNumbers.length == 6) {
              Navigator.of(context).pop();
              // 선택된 번호를 처리하는 로직 추가
              print('Selected Numbers: $selectedNumbers');
            } else {
              // 번호가 6개 선택되지 않았을 때의 처리
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('번호를 6개 선택하세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}