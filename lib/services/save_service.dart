import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

/// Oyun durumunu cihaz üzerinde (SharedPreferences) kaydeder/yükler.
class SaveService {
  static const _key = 'miyav_kafe_save_v1';

  static Future<void> save(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state.encode());
  }

  static Future<GameState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return GameState.fresh();
    try {
      return GameState.decode(raw);
    } catch (_) {
      return GameState.fresh();
    }
  }
}
