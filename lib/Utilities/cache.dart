import 'dart:convert';

import 'package:btp_app_mac/Utilities/api_calls.dart';
import 'package:btp_app_mac/Utilities/extract_json_to_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class CacheService {
  static final _cacheService = CacheService._internal();

  factory CacheService() {
    return _cacheService;
  }

  CacheService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> openBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  void addData(String boxName, String key, dynamic value) {
    final box = Hive.box(boxName);
    box.put(key, value);
  }

  dynamic getData(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  void deleteData(String boxName, String key) {
    final box = Hive.box(boxName);
    box.delete(key);
  }

  void clearBox(String boxName) {
    final box = Hive.box(boxName);
    box.clear();
  }

  Future<void> closeBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.close();
  }

  Future<Map<String, dynamic>?> getMap(String type, String key) async {
    // final box = await Hive.openBox<String>(type);
    final cachedData = Hive.box(type).get(key);
    // print('get Map $type');
    // print(cachedData);
    if (cachedData != null) {
      final mapFromCache = json.decode(cachedData);
      return mapFromCache;
      // return cachedData;
    }
    return null;
  }

  Future<void> putMap(
      String type, String key, Map<String, dynamic> data) async {
    // final encodedData = json.encode(data);
    // await _preferences.setString(key, encodedData);
    final myBox = await Hive.openBox<String>(type);
    await myBox.put(key, json.encode(data));
  }

  Future<dynamic> getFromCache(String type, String id) async {
    // dynamic mapFromCache;
    dynamic mapFromCache = await getMap(type, id);
    if (mapFromCache == null) {
      // print('getFromCache');
      // print(type);
      // print(id);
      dynamic data = await getComponent(id, type);
      await putMap(type, id, data.toJson());
      return data;
    }
    mapFromCache['_id'] = id;
    // print('getFromCache');
    // print(mapFromCache);
    return extractData(mapFromCache, type);
  }

  Future<void> deleteMap(String type, String id) async {
    // final myBox = await Hive.openBox<String>(type);
    await Hive.box(type).delete('delete $id');
  }

  Future<void> updateBoxEntriesInDB(type) async {
    // final myBox = await Hive.openBox<String>(type);
    final keys = Hive.box(type).keys;
    for (final key in keys) {
      final keyarr = key.split(' ');
      if (keyarr[0] == 'delete') {
        //delete id
        //delete from frontend cache
        await deleteMap(type, keyarr[1]);
        //delete from backend
        await deleteComponent(keyarr[1], type);
      } else {
        //'substation' 'id'
        dynamic data = await getMap(type, keyarr[1]);
        data['_id'] = keyarr[1];
        await updateComponent(extractData(data, keyarr[0]), type);
      }
    }
  }

  Future<void> clearHiveCache() async {
    await Hive.deleteFromDisk();
  }

  Future<void> updateAllEntriesInDB() async {
    await updateBoxEntriesInDB('cable');
    await updateBoxEntriesInDB('rmu');
    //transformers to be deleted before substation due to backend implementation
    await updateBoxEntriesInDB('transformer');
    await updateBoxEntriesInDB('ltpanel');
    await updateBoxEntriesInDB('substation');
  }
}
