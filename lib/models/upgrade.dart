/// Kafedeki satın alınabilir yükseltmeleri temsil eder. Her seviye, hem
/// dokunuş başına kazancı hem de saniyelik otomatik kazancı artırabilir.
class UpgradeModel {
  final String id;
  final String name;
  final String description;
  final int baseCost;
  final double costGrowth;
  final double coinsPerSecondAdd;
  final double coinsPerTapAdd;
  int level;

  UpgradeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.baseCost,
    this.costGrowth = 1.15,
    this.coinsPerSecondAdd = 0,
    this.coinsPerTapAdd = 0,
    this.level = 0,
  });

  int get currentCost => (baseCost * _pow(costGrowth, level)).round();

  static double _pow(double base, int exp) {
    double r = 1;
    for (var i = 0; i < exp; i++) {
      r *= base;
    }
    return r;
  }

  Map<String, dynamic> toJson() => {'id': id, 'level': level};

  UpgradeModel copy() => UpgradeModel(
        id: id,
        name: name,
        description: description,
        baseCost: baseCost,
        costGrowth: costGrowth,
        coinsPerSecondAdd: coinsPerSecondAdd,
        coinsPerTapAdd: coinsPerTapAdd,
        level: level,
      );
}

/// Sabit yükseltme listesi — yeni bir yükseltme eklemek için buraya bir
/// satır eklemek yeterli.
List<UpgradeModel> defaultUpgradeRoster() => [
      UpgradeModel(
        id: 'daha_iyi_fincan',
        name: 'Daha İyi Fincanlar',
        description: 'Her serviste kazanılan parayı artırır.',
        baseCost: 25,
        coinsPerTapAdd: 1,
      ),
      UpgradeModel(
        id: 'barista',
        name: 'Yeni Barista',
        description: 'Saniyede otomatik kazanç ekler.',
        baseCost: 100,
        coinsPerSecondAdd: 1,
      ),
      UpgradeModel(
        id: 'espresso_makinesi',
        name: 'Espresso Makinesi',
        description: 'Otomatik kazancı belirgin şekilde artırır.',
        baseCost: 500,
        coinsPerSecondAdd: 5,
      ),
      UpgradeModel(
        id: 'ikinci_sube',
        name: 'İkinci Şube',
        description: 'Büyük bir otomatik kazanç sıçraması sağlar.',
        baseCost: 5000,
        coinsPerSecondAdd: 40,
      ),
    ];
