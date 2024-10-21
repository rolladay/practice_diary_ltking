import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kingoflotto/components/my_btn_container.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import 'package:kingoflotto/constants/fonts_constants.dart';
import 'package:kingoflotto/features/isar_db/isar_service.dart';
import 'package:kingoflotto/pages/setting_page.dart';
import '../components/ad_banner_widget.dart';
import '../components/flip_profile_card.dart';
import '../constants/color_constants.dart';
import '../features/auth/auth_service.dart';
import '../features/lotto_service/lotto_functions.dart';
import '../features/user_service/user_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  final isar = IsarService();
  bool _showFrontSide = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      if (_showFrontSide) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _showFrontSide = !_showFrontSide;
    });
  }

  // 인앱결제 부분 ************************************************
  final Map<int, String> rankProductIds = {
    1: 'rank_up_to_2',
    2: 'rank_up_to_3',
    3: 'rank_up_to_4',
    4: 'rank_up_to_5',
    5: 'rank_max_product',
  };

  Future<void> _handlePurchase(int currentRank) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 디버그 메시지 추가
    print('handlePurchase called with rank: $currentRank');

    final String productId = rankProductIds[currentRank] ?? 'default_product';
    print('Product ID: $productId');

    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      print('In-app purchase not available');
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('인앱결제를 사용할 수 없음')),
      );
      return;
    }

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails({productId});

    print('Product details response: $response');
    if (response.notFoundIDs.isNotEmpty) {
      print('Product not found: ${response.notFoundIDs}');
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('상품을 찾을 수 없음')),
      );
      return;
    }

    if (response.productDetails.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('상품정보를 찾을 수 없음')),
      );
      return;
    }

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: response.productDetails.first);

    try {
      print('Attempting to buy consumable');
      final bool success = await InAppPurchase.instance.buyConsumable(
        purchaseParam: purchaseParam,
      );
      print('Purchase success: $success');
      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('구매가 완료되었음')),
        );
        // TODO: 구매 성공 처리 (예: 사용자 랭크 업데이트)
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('구매실패')),
        );
      }
    } catch (error) {
      print('Purchase error: $error');
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('오류발생')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);
    final userModel = ref.watch(userModelNotifierProvider);
    final userModelClass = ref.watch(userModelNotifierProvider.notifier);
    

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                // Stroke Text
                Text(
                  '프로필',
                  style: appBarTitleTextStyleWithStroke,
                ),
                // Fill Text
                Text(
                  '프로필',
                  style: appBarTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SettingPage(),
                  transitionDuration: Duration.zero, // 애니메이션 시간 0으로 설정
                  reverseTransitionDuration: Duration.zero, // 뒤로 갈 때도 애니메이션 없이
                ),
              );
            },
            child: Image.asset(
              'assets/images/profile_setting.png',
              width: 32,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black, // 라인 색상
            height: 1.0, // 라인 두께
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const MySizedBox(height: 8),
            const AdBannerWidget(),
            const MySizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleCard,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(pi * _animation.value),
                            alignment: Alignment.center,
                            child: _animation.value <= 0.5
                                ? buildFlipProfileFront(
                                    userModel, buildTopNumbers)
                                : Transform(
                                    transform: Matrix4.identity()..rotateY(pi),
                                    alignment: Alignment.center,
                                    child:
                                        buildflipProfileRear(userModel),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Upgrade button tapped');
                if (userModel != null) {
                  _handlePurchase(userModel.rank);
                } else {
                  print('userModel is null');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용자 정보를 불러올 수 없습니다.')),
                  );
                }
              },
              child: MyBtnContainer(
                color: specialBlue,
                child: const Center(
                  child: Text(
                    '승급심사',
                    style: btnTextStyle,
                  ),
                ),
              ),
            ),
            const MySizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
