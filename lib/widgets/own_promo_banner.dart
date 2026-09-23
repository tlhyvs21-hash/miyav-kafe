import 'package:flutter/material.dart';

/// AdMob'dan tamamen bağımsız, bizim kontrolümüzde olan tanıtım alanı.
/// Burada istediğimiz zaman kendi ürün/hizmetimizi, başka bir oyunumuzu
/// veya bir duyuruyu gösterebiliriz. [enabled] false yapılırsa hiç görünmez,
/// böylece koddan açılıp kapatılması kolaydır.
class OwnPromoBanner extends StatelessWidget {
  final bool enabled;
  final String message;
  final VoidCallback? onTap;

  const OwnPromoBanner({
    super.key,
    this.enabled = true,
    this.message = 'Bizim diğer oyunlarımızı keşfet!',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        color: const Color(0xFFFFE082),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
