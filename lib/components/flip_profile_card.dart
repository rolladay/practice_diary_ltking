import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingoflotto/components/my_container.dart';
import '../constants/color_constants.dart';
import '../features/lotto_service/lotto_functions.dart';
import '../models/user_model/user_model.dart';
import 'my_setting_list.dart';
import 'my_sizedbox.dart';

String _getRankName(int userRank) {
  switch (userRank) {
    case 2:
      return '학습자';
    case 3:
      return '탐구자';
    case 4:
      return '선지자';
    case 5:
      return '로또킹';
    default:
      return '입문자'; // 기본값
  }
}

Color _getRankColor(int userRank) {
  switch (userRank) {
    case 2:
      return Colors.blue;
    case 3:
      return Colors.green;
    case 4:
      return Colors.purple;
    case 5:
      return Colors.red;
    default:
      return Colors.white; // 기본값
  }
}

Widget buildExperienceBar(UserModel userModel) {
  // Rank에 따른 최대 경험치 설정

  //   if (experience < 25) return 1;
  //   if (experience < 100) return 2;
  //   if (experience < 250) return 3;
  //   if (experience < 1000) return 4;
  //   if (experience < 5000) return 5;
  //   return 6; // 1000 이상일 경우도 5로 설정

  double maxExp;
  switch (userModel.rank) {
    //헉습자
    case 2:
      maxExp = 100;
      break;
    //탐구자
    case 3:
      maxExp = 250;
      break;
    // 선지자
    case 4:
      maxExp = 1000;
      break;
    //로또킹
    case 5:
      maxExp = 9999;
      break;
    //입문자
    default: // Rank 1의 경우
      maxExp = 25;
  }

  // 경험치가 최대값을 초과하면 최대값으로 설정
  double currentExp = userModel.exp;
  if (currentExp > maxExp) {
    currentExp = maxExp;
  }

  // 경험치 비율 계산 (0~1 사이의 값)
  double expRatio = currentExp / maxExp;

  return Container(
    width: double.infinity, // 최대 너비
    height: 20, // 고정 높이
    decoration: BoxDecoration(
      border: Border.all(color: primaryBlack),
      color: Colors.grey[300], // 바탕색
      borderRadius: BorderRadius.circular(4), // 둥근 모서리
    ),

    child: Stack(
      children: [
        FractionallySizedBox(
          widthFactor: expRatio, // 경험치 비율만큼 너비 조정
          child: Container(
            decoration: BoxDecoration(
              color: specialBlue, // 경험치 바 색상
              borderRadius: BorderRadius.circular(3), // 둥근 모서리
            ),
          ),
        ),
        Center(
          child: Text(
            '${currentExp.toInt()} / ${maxExp.toInt()}', // 현재 경험치 / 최대 경험치
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

MyContainer buildFlipProfileFront(
    UserModel? userModel, Widget Function(UserModel user) buildTopNumbers) {
  return MyContainer(
      upperChildColor: _getRankColor(userModel!.rank),
      upperChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Text('Player License'),
            const Spacer(),
            Text(
              // 여기 UserRank따라간다
              _getRankName(userModel.rank),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      bottomChild: Column(
        children: [
          const MySizedBox(height: 16),
          Container(
            width: 100.0, // 이미지의 너비
            height: 100.0, // 이미지의 높이
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black54, // 테두리 색상
                width: 1.5, // 테두리 두께
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: userModel.photoUrl,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
                placeholder: (context, url) => const Icon(Icons.downloading),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          // 여기서 쓰이는 UserModel은 riverpod에서 가져오는 값이다. 앱 실행시 쭉 관리되는 상태임.
          // 즉, 로그인 후부터 로그인한 유저의 UserModel 의 state를 가지고 보여주는 부분으로
          // fireStore와 통신이나 서버간 통신이 없음.
          const MySizedBox(height: 8),
          Text(
            userModel.displayName,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: primaryBlack),
          ),
          // 여기 유저 comment 들어갈 자리
          SizedBox(
            height: 32,
            width: 240,
            child: Center(
              child: Text(
                userModel.userComment,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.black45,
            ),
          ),
          const MySizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 92,
                  height: 54,
                  decoration: BoxDecoration(
                    color: primaryGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 적중률 소숫점3자리까지만
                      Text(
                        '${userModel.winningRate.toStringAsFixed(3)}%',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '적중률',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 92,
                  height: 54,
                  decoration: BoxDecoration(
                    color: primaryGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatTotalPrize(userModel.totalPrize),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '총상금',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                // 총경험치
                Container(
                  width: 92,
                  height: 54,
                  decoration: BoxDecoration(
                    color: primaryGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userModel.exp.toInt()}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '경험치',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const MySizedBox(height: 16),
          const Text(
            'Lucky Numbers',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const MySizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: primaryGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height: 54,
              child: buildTopNumbers(userModel),
            ),
          ),
        ],
      ),
      bottomHeight: 376);
}

MyContainer buildflipProfileRear(UserModel? userModel) {
  return MyContainer(
    upperChildColor: _getRankColor(userModel!.rank),
    upperChild: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Text('Player Information'),
          const Spacer(),
          Text(
            _getRankName(userModel.rank),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
    bottomChild: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MySizedBox(height: 16),
          const Text(
            '승급 필요 경험치',
            style: TextStyle(color: Colors.black54),
          ),
          const MySizedBox(height: 4),
          buildExperienceBar(userModel),
          const Spacer(),
          MySettingList(
              listKey: '누적게임수 | 비용',
              listValue:
                  '${(userModel.totalSpend / 1000).toInt()} | ${userModel.totalSpend.toInt()}'),
          MySettingList(
              listKey: '당첨게임수 | 상금',
              listValue:
                  '${userModel.wonGames} | ${userModel.totalPrize.toInt()}'),
          MySettingList(
              listKey: '5등이상 당첨확률',
              listValue:
                  '${userModel.totalSpend > 0 ? ((userModel.wonGames / (userModel.totalSpend / 1000)) * 100).toStringAsFixed(2) : '0.00'} %'),
          MySettingList(
              listKey: '수익률',
              listValue:
                  '${userModel.totalSpend > 0 ? (((userModel.totalPrize - userModel.totalSpend) / userModel.totalSpend) * 100).toStringAsFixed(2) : '0.00'} %'),
          const MySizedBox(height: 8),

          // Add more stats here
        ],
      ),
    ),
    bottomHeight: 376,
  );
}
