import "dart:async";
import "dart:core";
import "package:http/http.dart" as http;

import 'package:sqflite/sqflite.dart';

class CacheManager {
  Database db;

  // Call this immediately after instantiating new CacheManager
  Future<void> init() async {
    var dbPath = await getDatabasesPath();
    String path = dbPath + "cache.db";

    this.db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE cache (url TEXT PRIMARY KEY, resource TEXT NOT NULL)');
    });
  }

  // Returns raw response body
  Future<String> fetch(String url, {bool update=false}) async {
    List<Map> cached = await this.db.rawQuery("SELECT resource FROM cache WHERE url = ?", [ url ]);
    if (cached.length > 0 && !update) { // Something exists in the cache
      return cached[0]["resource"]; // Return the first result
    }

    final response = await http.get(url);
    if (response.statusCode < 200 || response.statusCode >= 300) { // Unsuccessful response
      throw response.statusCode;
    }

    await this.db.rawInsert("INSERT INTO cache (url, resource) VALUES (?, ?) ON CONFLICT(url) DO UPDATE SET resource = ?", [url, response.body, response.body]);
    return response.body;
  }
}
