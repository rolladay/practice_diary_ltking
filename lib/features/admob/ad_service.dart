import 'package:google_mobile_ads/google_mobile_ads.dart';


// AD몹서비스는 기성품으로 대략 정해져있어 따로 자세히 살펴보지 않는다.
class AdManager {
  late BannerAd _bannerAd;
  bool isBannerAdReady = false;

  void initializeBannerAd(Function onAdLoaded, Function(Ad, LoadAdError) onAdFailedToLoad) {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 테스트 광고 ID, 나중에 내 id로 변경
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isBannerAdReady = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );

    _bannerAd.load();
  }

  BannerAd get bannerAd => _bannerAd;

  void dispose() {
    _bannerAd.dispose();
  }
}