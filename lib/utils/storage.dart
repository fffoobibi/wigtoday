import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<bool> remove(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.remove(key);
  }

  static Future<bool> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.clear();
  }

  static Future<bool> setData<T>(String key, T data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (data is String) {
      return await sp.setString(key, data);
    } else if (data is List<String>) {
      return await sp.setStringList(key, data);
    } else if (data is double) {
      return await sp.setDouble(key, data);
    } else if (data is int) {
      return await sp.setInt(key, data);
    } else if (data is bool) {
      return await sp.setBool(key, data);
    } else if (data is String) {
      return await sp.setString(key, data);
    }
    return false;
  }

  static Future<dynamic> getData<T>(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (T == String) {
      return sp.getString(key);
    } else if (T == List<String>) {
      return sp.getStringList(key);
    } else if (T == double) {
      return sp.getDouble(key);
    } else if (T == int) {
      return sp.getInt(key);
    } else if (T == bool) {
      return sp.getBool(key);
    } else if (T == String) {
      return sp.getString(key);
    }
    return null;
  }
}
