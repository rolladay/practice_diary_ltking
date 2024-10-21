import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kingoflotto/components/my_sizedbox.dart';
import '../components/flip_profile_card.dart';
import '../constants/color_constants.dart';
import '../constants/fonts_constants.dart';
import '../features/lotto_service/lotto_functions.dart';
import '../features/lotto_service/lotto_result_manager.dart';
import '../features/user_service/user_provider.dart';
import '../models/lotto_result_model/lotto_result.dart';


class RankPage extends ConsumerStatefulWidget {
  const RankPage({super.key});

  @override
  ConsumerState<RankPage> createState() => _RankPageState();
}

class _RankPageState extends ConsumerState<RankPage> {
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedOrderBy = 'exp';
  LottoResult? _recentLottoResult;
  List<Map<String, dynamic>>? _cachedUsers; //아마도 rankings.doc 에서 가져온 유저리스트겠지?

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadRecentLottoResult();
    await _loadRankings();
  }

  // CachedLottoResult가 null일 수는 없음
  Future<void> _loadRecentLottoResult() async {
    try {
      LottoResult? result = await getCachedLottoResult();
      if (result != null) {
        setState(() {
          _recentLottoResult = result;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed Lotto Result loading.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading Lotto Result: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRankings() async {
    final cacheKey = 'rankings_cache_$_selectedOrderBy';
    final file = await DefaultCacheManager().getFileFromCache(cacheKey);
    final now = DateTime.now();
    if (file == null || now.isAfter(file.validTill)) {
      await _fetchAndCacheRankings();
    } else {
      _loadCachedRankings();
    }
  }

  DateTime _getNextSaturdayAt8_45PM() {
    final now = DateTime.now();
    final daysUntilSaturday = DateTime.saturday - now.weekday;
    final nextSaturday =
        now.add(Duration(days: daysUntilSaturday > 0 ? daysUntilSaturday : 7));
    return DateTime(
        nextSaturday.year, nextSaturday.month, nextSaturday.day, 20, 46);
  }

  Future<void> _fetchAndCacheRankings() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rankings')
          .doc(_selectedOrderBy)
          .get();
      if (snapshot.exists) {
        final users =
            List<Map<String, dynamic>>.from(snapshot.data()!['users']);
        final jsonStr = jsonEncode(users);
        final nextExpiration = _getNextSaturdayAt8_45PM();
        final cacheKey = 'rankings_cache_$_selectedOrderBy';
        await DefaultCacheManager().putFile(
          cacheKey,
          Uint8List.fromList(utf8.encode(jsonStr)),
          maxAge: nextExpiration.difference(DateTime.now()),
          eTag: nextExpiration.toIso8601String(),
        );
        setState(() {
          _cachedUsers = users;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No rankings available.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching rankings: $e';
        _isLoading = false;
      });
    }
  }

  void _loadCachedRankings() async {
    try {
      final cacheKey = 'rankings_cache_$_selectedOrderBy';
      final file = await DefaultCacheManager().getFileFromCache(cacheKey);
      if (file != null) {
        final jsonStr = await file.file.readAsString();
        setState(() {
          _cachedUsers = List<Map<String, dynamic>>.from(jsonDecode(jsonStr));
          _isLoading = false;
        });
      } else {
        await _fetchAndCacheRankings();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading cached rankings: $e';
        _isLoading = false;
      });
    }
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: backGroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Container(
                height: 3,
                width: 60,
                color: primaryBlack,
              ),
              const Spacer(),
              ListTile(
                title: Center(
                  child: Text(
                    '경험치',
                    style: TextStyle(fontSize: 14, color: primaryBlack),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedOrderBy = 'exp';
                  });
                  Navigator.pop(context);
                  _loadRankings();
                },
              ),
              ListTile(
                title: Center(
                  child: Text(
                    '총 상금',
                    style: TextStyle(fontSize: 14, color: primaryBlack),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedOrderBy = 'totalPrize';
                  });
                  Navigator.pop(context);
                  _loadRankings();
                },
              ),
              ListTile(
                title: Center(
                  child: Text(
                    '적중률',
                    style: TextStyle(fontSize: 14, color: primaryBlack),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedOrderBy = 'winningRate';
                  });
                  Navigator.pop(context);
                  _loadRankings();
                },
              ),
              const MySizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _getSelectedOrderValue(Map<String, dynamic> user) {
    switch (_selectedOrderBy) {
      case 'exp':
        return '${user['exp']}';
      case 'totalPrize':
        return formatTotalPrize(user['totalPrize']);
      case 'winningRate':
        if (user['winningRate'] is double) {
          return '${(user['winningRate'] as double).toStringAsFixed(3)}%';
        } else if (user['winningRate'] is int) {
          return '${(user['winningRate'] as int).toDouble().toStringAsFixed(3)}%';
        } else {
          return '${user['winningRate']}%';
        }
      default:
        return '';
    }
  }

  String _getSelectedOrderText(String selectedOrder) {
    switch (selectedOrder) {
      case 'totalPrize':
        return '총 상금';
      case 'winningRate':
        return '적중률';
      default:
        return '경험치'; // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryOrange,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Text('랭크', style: appBarTitleTextStyleWithStroke),
                Text('랭크', style: appBarTitleTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _showSortMenu(context),
            child: Image.asset(
              'assets/images/rank_order.png',
              width: 32,
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getSelectedOrderText(_selectedOrderBy), // 메소드 사용
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        'Updated : ${_recentLottoResult != null ? DateFormat('yyyy-MM-dd').format(_recentLottoResult!.drawDate) : '알 수 없음'}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : ListView.builder(
                        itemCount: _cachedUsers?.length ?? 0,
                        itemBuilder: (context, index) {
                          var user = _cachedUsers![index];
                          return GestureDetector(
                            // 탭할때마다 파베 read 요청이 있음. 나중에 cached등 최적화 필요 (유효기간 설정 등)

                              onTap: () async {
                                final BuildContext currentContext = context;

                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    systemNavigationBarColor: Color.fromARGB(255, 111, 46, 18),
                                    systemNavigationBarIconBrightness: Brightness.light,
                                  ),
                                );

                                try {
                                  final userModelNotifier = ref.read(userModelNotifierProvider.notifier);
                                  final userModel = await userModelNotifier.fetchUserWithoutStateUpdate(user['id']);

                                  if (userModel != null && currentContext.mounted) {
                                    showDialog(
                                      context: currentContext,
                                      useSafeArea: false,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                buildFlipProfileFront(userModel, buildTopNumbers),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).whenComplete(() {
                                      SystemChrome.setSystemUIOverlayStyle(
                                        const SystemUiOverlayStyle(
                                          systemNavigationBarColor: Color.fromARGB(255, 216, 89, 37),
                                          systemNavigationBarIconBrightness: Brightness.light,
                                        ),
                                      );
                                    });
                                  }
                                } catch (e) {
                                  print('Error showing user profile: $e');
                                }
                              },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4,16,4),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CachedNetworkImage(
                                      imageUrl: user['photoUrl'],
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 16,
                                        backgroundImage: imageProvider,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      placeholder: (context, url) => const Icon(
                                        Icons.downloading,
                                        size: 32,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(user['displayName']),
                                    const Spacer(),
                                    Text(_getSelectedOrderValue(user)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
