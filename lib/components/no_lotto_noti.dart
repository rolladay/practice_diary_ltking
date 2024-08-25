import 'package:flutter/material.dart';

import 'my_sizedbox.dart';



class NoLottoNoti extends StatelessWidget {
  const NoLottoNoti({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/bnb_lotto_select.png',
          width: 80,
        ),
        const MySizedBox(height: 20),
        const Center(
          child: Text(
            '이번 회차에 등록한 게임이 없으시군요! \n번호를 뽑든 구매한 로또를 등록하든 하세요.',
            style: TextStyle(
                color: Colors.black45, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
