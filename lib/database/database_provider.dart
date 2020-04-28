import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  static final DataBaseProvider _singleton = DataBaseProvider._internal();

  factory DataBaseProvider() {
    return _singleton;
  }

  DataBaseProvider._internal();

  static Database _database;
  final initialScript = [
    'CREATE TABLE brewer(id TEXT PRIMARY KEY,)',
    'CREATE TABLE beer(id TEXT PRIMARY KEY, )',
    'CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT,)',
  ];

  Future<Database> getDataBase() async {
    if (_database != null) {
      return _database;
    } else {
      _database = await getDatabasesPath().then((String path) async {
        print('path $path');
        String dbPath = join(path, 'craftbeerco.db');
        print('joined path $dbPath');
        return await openDatabase(
          dbPath,
          onCreate: (db, version) async {
            initialScript.forEach((script) async {
              await db.execute(script);
            });
          },
          version: 1,
        );
      }, onError: (error) {
        print("Ocurrió un error { database.dart } $error");
      });
      print('db ${_database != null}');
      return _database;
    }
  }
}
