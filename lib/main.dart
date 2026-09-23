import 'package:flutter/material.dart';
import 'services/ad_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.init();
  runApp(const MiyavKafeApp());
}

class MiyavKafeApp extends StatelessWidget {
  const MiyavKafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miyav Kafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF8A65),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
