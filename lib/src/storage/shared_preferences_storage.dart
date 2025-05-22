import 'storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements Storage {
  final SharedPreferences _prefs;

  SharedPreferencesStorage(this._prefs);

  @override
  Future<void> setValue<T>(String key, T value) async {
    if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw UnsupportedError('Type ${T.runtimeType} is not supported');
    }
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final value = _prefs.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
