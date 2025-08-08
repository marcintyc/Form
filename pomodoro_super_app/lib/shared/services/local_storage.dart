import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> setString(String key, String value) async {
    final p = await _prefs();
    await p.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final p = await _prefs();
    return p.getString(key);
  }

  static Future<void> setJson(String key, Object value) async {
    await setString(key, jsonEncode(value));
  }

  static Future<dynamic> getJson(String key) async {
    final s = await getString(key);
    if (s == null) return null;
    return jsonDecode(s);
  }

  static Future<void> setInt(String key, int value) async {
    final p = await _prefs();
    await p.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final p = await _prefs();
    return p.getInt(key);
  }
}