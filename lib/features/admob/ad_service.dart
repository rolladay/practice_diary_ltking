import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_service.g.dart';

class AdState {
  final bool isReady;
  final BannerAd? ad;
  AdState({required this.isReady, this.ad});
}

@Riverpod(keepAlive: true)
class AdManager extends _$AdManager {
  late BannerAd _bannerAd;

  @override
  AdState build() {
    _initializeBannerAd();
    return AdState(isReady: false, ad: null);
  }

  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 테스트 광고 ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          state = AdState(isReady: true, ad: _bannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          state = AdState(isReady: false, ad: null);
          print('BannerAd failed to load: $error');
        },
      ),
    );

    _bannerAd.load();
  }
}