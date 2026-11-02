import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mengatur mode tema (light / dark / system) dan menyimpannya ke
/// shared_preferences agar pilihan tema tetap ada saat aplikasi dibuka lagi.
class ThemeController extends ChangeNotifier {
  static const String _storageKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Membaca pilihan tema yang tersimpan. Jika gagal, tema mengikuti sistem.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved == 'light') {
        _themeMode = ThemeMode.light;
      } else if (saved == 'dark') {
        _themeMode = ThemeMode.dark;
      }
      notifyListeners();
    } catch (_) {
      // Abaikan: aplikasi tetap berjalan dengan tema sistem.
    }
  }

  /// Mengganti tema dan langsung menerapkannya ke seluruh halaman.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {
      // Penyimpanan gagal tidak mengganggu tampilan.
    }
  }
}

/// Membagikan [ThemeController] ke seluruh widget di bawahnya.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope tidak ditemukan di widget tree.');
    return scope!.notifier!;
  }
}
