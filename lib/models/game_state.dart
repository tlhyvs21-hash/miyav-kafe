import 'dart:convert';
import 'cat.dart';
import 'upgrade.dart';

/// Oyunun tüm ilerlemesini tutan tek merkezi durum nesnesi.
/// JSON'a çevrilip SharedPreferences ile diske kaydedilir.
class GameState {
  double coins;
  int totalTaps;
  List<CatModel> cats;
  List<UpgradeModel> upgrades;
  DateTime lastSeen;

  GameState({
    required this.coins,
    required this.totalTaps,
    required this.cats,
    required this.upgrades,
    required this.lastSeen,
  });

  factory GameState.fresh() => GameState(
        coins: 0,
        totalTaps: 0,
        cats: defaultCatRoster(),
        upgrades: defaultUpgradeRoster(),
        lastSeen: DateTime.now(),
      );

  double get coinsPerTap {
    double base = 1;
    for (final u in upgrades) {
      base += u.coinsPerTapAdd * u.level;
    }
    return base;
  }

  double get coinsPerSecond {
    double base = 0;
    for (final u in upgrades) {
      base += u.coinsPerSecondAdd * u.level;
    }
    double multiplier = 1;
    for (final c in cats) {
      if (c.unlocked) multiplier += c.bonusMultiplier;
    }
    return base * multiplier;
  }

  void serveTap() {
    coins += coinsPerTap;
    totalTaps += 1;
  }

  bool buyUpgrade(String id) {
    final u = upgrades.firstWhere((e) => e.id == id);
    final cost = u.currentCost;
    if (coins < cost) return false;
    coins -= cost;
    u.level += 1;
    return true;
  }

  bool unlockCat(String id) {
    final c = cats.firstWhere((e) => e.id == id);
    if (c.unlocked || coins < c.unlockCost) return false;
    coins -= c.unlockCost;
    c.unlocked = true;
    return true;
  }

  /// Oyuncu uzak kaldığı sürede kazandığı parayı hesaplar (en fazla 8 saat
  /// sayılır, böylece hem ödüllendirici hem de dengeli kalır).
  double applyOfflineEarnings() {
    final now = DateTime.now();
    final seconds = now.difference(lastSeen).inSeconds.clamp(0, 8 * 60 * 60);
    final earned = coinsPerSecond * seconds;
    coins += earned;
    lastSeen = now;
    return earned;
  }

  Map<String, dynamic> toJson() => {
        'coins': coins,
        'totalTaps': totalTaps,
        'cats': cats.map((c) => c.toJson()).toList(),
        'upgrades': upgrades.map((u) => u.toJson()).toList(),
        'lastSeen': lastSeen.toIso8601String(),
      };

  static GameState fromJson(Map<String, dynamic> json) {
    final catTemplates = defaultCatRoster();
    final upgradeTemplates = defaultUpgradeRoster();

    final catsJson = (json['cats'] as List?) ?? [];
    final cats = catTemplates.map((t) {
      Map<String, dynamic>? match;
      for (final j in catsJson) {
        if (j is Map<String, dynamic> && j['id'] == t.id) {
          match = j;
          break;
        }
      }
      return CatModel.fromTemplateWithJson(t, match);
    }).toList();

    final upgradesJson = (json['upgrades'] as List?) ?? [];
    final upgrades = upgradeTemplates.map((t) {
      Map<String, dynamic>? match;
      for (final j in upgradesJson) {
        if (j is Map<String, dynamic> && j['id'] == t.id) {
          match = j;
          break;
        }
      }
      final u = t.copy();
      if (match != null) u.level = match['level'] as int? ?? 0;
      return u;
    }).toList();

    return GameState(
      coins: (json['coins'] as num?)?.toDouble() ?? 0,
      totalTaps: json['totalTaps'] as int? ?? 0,
      cats: cats,
      upgrades: upgrades,
      lastSeen: DateTime.tryParse(json['lastSeen'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String encode() => jsonEncode(toJson());
  static GameState decode(String raw) => GameState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
