import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/logger.dart';

class CacheService {
  static SharedPreferences? _prefs;

  static void init(SharedPreferences prefs) {
    _prefs = prefs;
    AppLogger.info('CacheService initialized');
  }

  static Future<void> initAsync() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('CacheService initialized async');
  }

  static Future<bool> setString(String key, String value) async {
    AppLogger.debug('Cache set string: $key');
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    AppLogger.debug('Cache set bool: $key');
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    AppLogger.debug('Cache set int: $key');
    return await _prefs?.setInt(key, value) ?? false;
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    AppLogger.debug('Cache set json: $key');
    return await _prefs?.setString(key, jsonEncode(value)) ?? false;
  }

  static Map<String, dynamic>? getJson(String key) {
    final string = _prefs?.getString(key);
    if (string == null) return null;
    try {
      return jsonDecode(string) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Error decoding JSON from cache', e);
      return null;
    }
  }

  static Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    AppLogger.debug('Cache set json list: $key');
    return await _prefs?.setString(key, jsonEncode(value)) ?? false;
  }

  static List<Map<String, dynamic>>? getJsonList(String key) {
    final string = _prefs?.getString(key);
    if (string == null) return null;
    try {
      final list = jsonDecode(string) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      AppLogger.error('Error decoding JSON list from cache', e);
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    AppLogger.debug('Cache remove: $key');
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    AppLogger.warning('Clearing all cache');
    return await _prefs?.clear() ?? false;
  }

  static bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  static Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }
}
