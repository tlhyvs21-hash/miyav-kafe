import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/game_state.dart';
import '../services/save_service.dart';
import '../services/ad_service.dart';
import '../widgets/own_promo_banner.dart';
import '../widgets/cat_illustration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameState? _state;
  Timer? _tickTimer;
  Timer? _saveTimer;
  BannerAd? _banner;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  int _upgradePurchases = 0;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final loaded = await SaveService.load();
    final earned = loaded.applyOfflineEarnings();
    setState(() => _state = loaded);

    if (earned > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOfflineEarningsDialog(earned));
    }

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == null) return;
      setState(() => _state!.coins += _state!.coinsPerSecond);
    });

    _saveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_state != null) SaveService.save(_state!);
    });

    _banner = AdService.createBanner(onLoaded: () => setState(() {}));
    AdService.loadRewarded((ad) => _rewardedAd = ad);
    AdService.loadInterstitial((ad) => _interstitialAd = ad);
  }

  void _showOfflineEarningsDialog(double earned) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hoş geldin!'),
        content: Text('Yokluğunda kafen ${earned.toStringAsFixed(0)} altın kazandı.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Harika!')),
        ],
      ),
    );
  }

  void _onServeTap() => setState(() => _state!.serveTap());

  void _onBuyUpgrade(String id) {
    setState(() {
      final ok = _state!.buyUpgrade(id);
      if (ok) {
        _upgradePurchases++;
        if (_upgradePurchases % 5 == 0 && _interstitialAd != null) {
          _interstitialAd!.show();
          AdService.loadInterstitial((ad) => _interstitialAd = ad);
        }
      }
    });
  }

  void _onWatchRewarded() {
    final ad = _rewardedAd;
    if (ad == null) return;
    ad.show(onUserEarnedReward: (_, __) {
      setState(() => _state!.coins += _state!.coinsPerSecond * 60 * 2);
    });
    AdService.loadRewarded((a) => _rewardedAd = a);
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _saveTimer?.cancel();
    _banner?.dispose();
    if (_state != null) SaveService.save(_state!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    if (state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Miyav Kafe'),
        backgroundColor: const Color(0xFFFF8A65),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const OwnPromoBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '🪙 ${state.coins.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Saniyede: ${state.coinsPerSecond.toStringAsFixed(1)}'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _onServeTap,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF8D6E63),
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: const Center(
                  child: Text(
                    'Servis Et ☕',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _rewardedAd == null ? null : _onWatchRewarded,
              icon: const Icon(Icons.play_circle),
              label: const Text('İzle: 2 dakikalık kazancı 2 katına çıkar'),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const Text('Yükseltmeler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ...state.upgrades.map((u) => ListTile(
                        title: Text('${u.name} (Lv ${u.level})'),
                        subtitle: Text(u.description),
                        trailing: ElevatedButton(
                          onPressed: state.coins >= u.currentCost ? () => _onBuyUpgrade(u.id) : null,
                          child: Text('${u.currentCost} 🪙'),
                        ),
                      )),
                  const SizedBox(height: 12),
                  const Text('Kediler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.cats
                          .map((c) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: c.unlocked ? null : () => setState(() => _state!.unlockCat(c.id)),
                                  child: Column(
                                    children: [
                                      CatIllustration(locked: !c.unlocked),
                                      Text(c.unlocked ? c.name : '${c.unlockCost} 🪙'),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            if (_banner != null)
              SizedBox(
                height: _banner!.size.height.toDouble(),
                width: _banner!.size.width.toDouble(),
                child: AdWidget(ad: _banner!),
              ),
          ],
        ),
      ),
    );
  }
}
