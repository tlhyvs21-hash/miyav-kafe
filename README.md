# Miyav Kafe

Kedi dostu, idle/tycoon tarzında bir kafe işletme oyunu. Flutter (Dart) ile
yazıldı; tek kod tabanından ileride hem Android hem iOS'a derlenebilir.
Şu an yalnızca Android hedefleniyor.

## Neden bu klasör böyle?

`lib/` klasöründeki oyun kodu elle yazıldı, ama `android/` gibi platform
klasörleri burada YOK — bunlar GitHub Actions iş akışı (`.github/workflows/build-apk.yml`)
tarafından derleme sırasında otomatik oluşturuluyor. Bunun sebebi: bu kodun
yazıldığı ortamın (Claude'un bulut ortamı) ağ politikası, Flutter'ın
platform dosyalarını indirdiği Google sunucularına erişemiyor. GitHub
Actions'ın çalıştığı sunucularda bu kısıt yok, bu yüzden derleme orada
yapılıyor.

## APK'yı nasıl indiririm?

1. Bu depoyu GitHub'da `main` dalına push edin (veya "Actions" sekmesinden
   "Android APK Derle" iş akışını elle çalıştırın — "Run workflow" düğmesi).
2. İş akışı bitince (birkaç dakika sürer), o çalıştırmanın sayfasında
   "Artifacts" bölümünden `miyav-kafe-apk` dosyasını indirin — içinde
   `app-release.apk` var.
3. Bu APK'yı Android telefonunuza kopyalayıp doğrudan kurabilir, ya da
   ileride Google Play Console'a yükleyebilirsiniz.

## Şu anki durum

- Reklamlar Google'ın herkese açık TEST kimlikleriyle çalışıyor — gerçek
  gelir üretmez. Gerçek bir AdMob hesabı açıldığında `lib/services/ad_service.dart`
  içindeki üç kimlik ve `.github/workflows/build-apk.yml` içindeki
  AdMob App ID gerçek değerlerle değiştirilecek.
- Görseller tamamen kodla çizilen basit vektörel illüstrasyonlar
  (`lib/widgets/cat_illustration.dart`) — profesyonel bir grafiker
  olmadan üretilebilir olması için böyle tasarlandı.
- Oyun adı "Miyav Kafe" bir çalışma adı; kesinleşmedi.

Projenin tam yol haritası ve kararların gerekçesi için canlı proje
özeti dokümanına bakabilirsiniz (Claude ile konuşmanızda paylaşıldı).
