import 'dart:convert';

import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:btp_app_mac/Utilities/extract_json_to_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<Map<String, dynamic>?> getMap(String type, String id) async {
    String key = '$type $id';
    final cachedData = _preferences.getString(key);
    if (cachedData != null) {
      final mapFromCache = json.decode(cachedData);
      return mapFromCache;
    }
    return null;
  }

  static Future<dynamic> getFromCache(String type, String id) async {
    final mapFromCache = await getMap(type, id);
    if (mapFromCache == null) return await getComponent(id, type);
    mapFromCache!['_id'] = id;
    return extractData(mapFromCache, type);
  }

  static Future<void> putMap(
      String type, String id, Map<String, dynamic> data) async {
    String key = '$type $id';
    final encodedData = json.encode(data);
    await _preferences.setString(key, encodedData);
  }

  static Future<void> deleteMap(String type, String id) async {
    await _preferences.remove('$type $id');
  }

  static Future<void> updateAllEntriesInDB() async {
    final keys = _preferences.getKeys();
    List<String> keysToBeRemoved = [];
    for (final key in keys) {
      final keyarr = key.split(' ');
      if (keyarr[0] == 'delete') {
        //delete substation id
        keysToBeRemoved.add(key);
        //substation id
        keysToBeRemoved.add('${keyarr[1]} ${keyarr[2]}');
      } else {
        //'substation' 'id'
        dynamic data = getMap(keyarr[0], keyarr[1]);
        data['_id'] = keyarr[1];
        await updateComponent(extractData(data, keyarr[0]), keyarr[0]);
      }
    }
    // remove deleted elements from cache.
    for (final key in keysToBeRemoved) {
      final keyarr = key.split(' ');
      //delete from frontend cache
      await deleteMap(keyarr[0], keyarr[1]);
      //delete from backend
      await deleteComponent(keyarr[1], keyarr[0]);
    }
  }
}
