import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob entegrasyonu.
///
/// ŞU AN Google'ın herkese açık TEST reklam kimlikleriyle çalışıyor —
/// gerçek bir AdMob hesabı açıldığında bu üç kimlik ve AndroidManifest'teki
/// APPLICATION_ID, kendi ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY
/// değerlerinizle değiştirilecek. Test kimlikleriyle gerçek para kazanılmaz,
/// sadece entegrasyonun çalıştığı doğrulanır.
class AdService {
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  static BannerAd createBanner({required void Function() onLoaded}) {
    final banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) => onLoaded()),
    );
    banner.load();
    return banner;
  }

  static void loadInterstitial(void Function(InterstitialAd ad) onLoaded) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (_) {},
      ),
    );
  }

  static void loadRewarded(void Function(RewardedAd ad) onLoaded) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (_) {},
      ),
    );
  }
}
