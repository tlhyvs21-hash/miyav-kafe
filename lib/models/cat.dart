/// Oyundaki kedi karakterlerini temsil eder. Her kedi, saniyelik otomatik
/// kazanca bir çarpan bonusu ekler ve belirli bir maliyetle açılır.
class CatModel {
  final String id;
  final String name;
  final int unlockCost;
  final double bonusMultiplier;
  bool unlocked;

  CatModel({
    required this.id,
    required this.name,
    required this.unlockCost,
    required this.bonusMultiplier,
    this.unlocked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'unlocked': unlocked,
      };

  static CatModel fromTemplateWithJson(CatModel template, Map<String, dynamic>? json) {
    final c = template.copy();
    if (json != null) {
      c.unlocked = json['unlocked'] as bool? ?? false;
    }
    return c;
  }

  CatModel copy() => CatModel(
        id: id,
        name: name,
        unlockCost: unlockCost,
        bonusMultiplier: bonusMultiplier,
        unlocked: unlocked,
      );
}

/// Sabit kedi listesi — ileride kolayca genişletilebilir (yeni kedi eklemek
/// için buraya bir satır eklemek yeterli).
List<CatModel> defaultCatRoster() => [
      CatModel(id: 'tekir', name: 'Tekir', unlockCost: 50, bonusMultiplier: 0.5),
      CatModel(id: 'sarman', name: 'Sarman', unlockCost: 200, bonusMultiplier: 1.2),
      CatModel(id: 'siyah_inci', name: 'Siyah İnci', unlockCost: 750, bonusMultiplier: 2.5),
      CatModel(id: 'patili', name: 'Patili', unlockCost: 2500, bonusMultiplier: 5.0),
      CatModel(id: 'prens', name: 'Prens', unlockCost: 8000, bonusMultiplier: 10.0),
    ];
