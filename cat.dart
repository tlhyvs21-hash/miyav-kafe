/// Oyundaki kedi karakterlerini temsil eder. Her kedi, saniyelik otomatik
/// kazanca bir çarpan bonusu ekler, kendine özgü bir renge ve küçük bir
/// görsel özelliğe (desen/aksesuar) sahiptir.
enum CatFeature { none, stripes, chestPatch, pawMark, crown }

class CatModel {
  final String id;
  final String name;
  final int unlockCost;
  final double bonusMultiplier;
  final int colorValue;
  final CatFeature feature;
  bool unlocked;

  CatModel({
    required this.id,
    required this.name,
    required this.unlockCost,
    required this.bonusMultiplier,
    required this.colorValue,
    this.feature = CatFeature.none,
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
        colorValue: colorValue,
        feature: feature,
        unlocked: unlocked,
      );
}

/// Sabit kedi listesi — her birinin kendine has bir rengi ve küçük bir
/// görsel özelliği var, böylece koleksiyon ekranı tek tip görünmüyor.
/// Yeni bir kedi eklemek için buraya bir satır eklemek yeterli.
List<CatModel> defaultCatRoster() => [
      CatModel(
        id: 'tekir',
        name: 'Tekir',
        unlockCost: 50,
        bonusMultiplier: 0.5,
        colorValue: 0xFFC98A4B,
        feature: CatFeature.stripes,
      ),
      CatModel(
        id: 'sarman',
        name: 'Sarman',
        unlockCost: 200,
        bonusMultiplier: 1.2,
        colorValue: 0xFFE8A33D,
      ),
      CatModel(
        id: 'siyah_inci',
        name: 'Siyah İnci',
        unlockCost: 750,
        bonusMultiplier: 2.5,
        colorValue: 0xFF3A3A3A,
        feature: CatFeature.chestPatch,
      ),
      CatModel(
        id: 'patili',
        name: 'Patili',
        unlockCost: 2500,
        bonusMultiplier: 5.0,
        colorValue: 0xFFF3E4D0,
        feature: CatFeature.pawMark,
      ),
      CatModel(
        id: 'prens',
        name: 'Prens',
        unlockCost: 8000,
        bonusMultiplier: 10.0,
        colorValue: 0xFF8E6BC7,
        feature: CatFeature.crown,
      ),
    ];
