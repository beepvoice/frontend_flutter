import "dart:async";
import "dart:core";
import "package:http/http.dart" as http;

import 'package:sqflite/sqflite.dart';

class CacheHttp {
  static final CacheHttp _cache = new CacheHttp._internal();

  factory CacheHttp() {
    return _cache;
  }

  CacheHttp._internal();

  Database db;
  bool hasInit = false;

  // Call this immediately after instantiating new CacheManager
  Future<void> init() async {
    var dbPath = await getDatabasesPath();
    String path = dbPath + "/cache.db";
    this.db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE cache (url TEXT PRIMARY KEY, resource TEXT NOT NULL)');
    });
  }

  // Returns raw response body
  Future<String> fetch(String url,
      {bool update = false, Map<String, String> headers = const {}}) async {
    if (!this.hasInit) {
      await this.init();
      this.hasInit = true;
    }
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return response.body;
      } else {
        await this.db.rawInsert(
            "INSERT INTO cache (url, resource) VALUES (?, ?) ON CONFLICT(url) DO UPDATE SET resource = ?",
            [url, response.body, response.body]);
        return response.body;
      }
    } catch (e) {
      final body = await this.getCache(url);
      return body;
    }
  }

  Future<String> getCache(String url) async {
    if (!this.hasInit) {
      print("UNINIT");
    }
    List<Map> cached = await this
        .db
        .rawQuery("SELECT resource FROM cache WHERE url = ?", [url]);
    if (cached.length > 0) {
      // Something exists in the cache
      return cached[0]["resource"]; // Return the first result
    } else {
      throw new Exception("Network unavailable and not in cache");
    }
  }
}
