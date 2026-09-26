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
        title: const Text('Miyav Kafe', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFF8A65),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE0B2), Color(0xFFFFF3E0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const OwnPromoBanner(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Text(
                    '🪙 ${state.coins.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF6D4C41)),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Saniyede: ${state.coinsPerSecond.toStringAsFixed(1)} 🪙',
                style: const TextStyle(color: Color(0xFF8D6E63), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: _onServeTap,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFA1786A), Color(0xFF6D4C41)],
                    ),
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Center(
                    child: Text(
                      'Servis Et ☕',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                  const SizedBox(height: 6),
                  ...state.upgrades.map((u) => Card(
                        elevation: 1.5,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          title: Text('${u.name} (Lv ${u.level})', style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(u.description),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8A65),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: state.coins >= u.currentCost ? () => _onBuyUpgrade(u.id) : null,
                            child: Text('${u.currentCost} 🪙'),
                          ),
                        ),
                      )),
                  const SizedBox(height: 12),
                  const Text('Kediler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 128,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.cats
                          .map((c) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: GestureDetector(
                                  onTap: c.unlocked ? null : () => setState(() => _state!.unlockCat(c.id)),
                                  child: Container(
                                    width: 96,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: c.unlocked
                                          ? Color(c.colorValue).withOpacity(0.16)
                                          : Colors.black.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: c.unlocked ? Color(c.colorValue).withOpacity(0.5) : Colors.black12,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CatIllustration(
                                          color: Color(c.colorValue),
                                          locked: !c.unlocked,
                                          feature: c.feature,
                                          size: 60,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          c.unlocked ? c.name : '${c.unlockCost} 🪙',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}
