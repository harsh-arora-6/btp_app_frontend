import 'dart:convert';

import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:btp_app_mac/Utilities/extract_json_to_model.dart';
import 'package:hive/hive.dart';

class CacheService {
  static Future<Map<String, dynamic>?> getMap(String type, String key) async {
    final box = await Hive.openBox<String>(type);
    final cachedData = box.get(key);
    print('get Map $type');
    print(cachedData);
    if (cachedData != null) {
      final mapFromCache = json.decode(cachedData);
      return mapFromCache;
      // return cachedData;
    }
    return null;
  }

  static Future<void> putMap(
      String type, String key, Map<String, dynamic> data) async {
    // final encodedData = json.encode(data);
    // await _preferences.setString(key, encodedData);
    final myBox = await Hive.openBox<String>(type);
    await myBox.put(key, json.encode(data));
  }

  static Future<dynamic> getFromCache(String type, String id) async {
    // dynamic mapFromCache;
    dynamic mapFromCache = await CacheService.getMap(type, id);
    if (mapFromCache == null) {
      // print('getFromCache');
      // print(type);
      // print(id);
      dynamic data = await getComponent(id, type);
      await CacheService.putMap(type, id, data.toJson());
      return data;
    }
    mapFromCache['_id'] = id;
    // print('getFromCache');
    // print(mapFromCache);
    return extractData(mapFromCache, type);
  }

  static Future<void> deleteMap(String type, String id) async {
    final myBox = await Hive.openBox<String>(type);
    await myBox.delete('delete $id');
  }

  static Future<void> updateBoxEntriesInDB(type) async {
    final myBox = await Hive.openBox<String>(type);
    final keys = myBox.keys;
    for (final key in keys) {
      final keyarr = key.split(' ');
      if (keyarr[0] == 'delete') {
        //delete id
        //delete from frontend cache
        await CacheService.deleteMap(type, keyarr[1]);
        //delete from backend
        await deleteComponent(keyarr[1], type);
      } else {
        //'substation' 'id'
        dynamic data = await CacheService.getMap(type, keyarr[1]);
        data['_id'] = keyarr[1];
        await updateComponent(extractData(data, keyarr[0]), type);
      }
    }
  }

  static Future<void> clearHiveCache() async {
    await Hive.deleteFromDisk();
  }

  static Future<void> updateAllEntriesInDB() async {
    await CacheService.updateBoxEntriesInDB('cable');
    await CacheService.updateBoxEntriesInDB('rmu');
    //transformer has to be deleted before substation due to backend implementation
    await CacheService.updateBoxEntriesInDB('transformer');
    await CacheService.updateBoxEntriesInDB('ltpanel');
    await CacheService.updateBoxEntriesInDB('substation');
  }
}
