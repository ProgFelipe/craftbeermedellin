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
    //FOR CACHING
    'CREATE TABLE brewer(id INTEGER PRIMARY KEY, name TEXT, '
        'description TEXT, imageUri TEXT, aboutUs TEXT, phone TEXT,'
        ' instagram TEXT, facebook TEXT, youtube TEXT, website TEXT,'
        ' can_sale INTEGER, favorite INTEGER)',
    'CREATE TABLE beer(id NUMERIC PRIMARY KEY, name TEXT, description TEXT, history TEXT, '
        'imageUri Text, type TEXT, flavors TEXT, scents TEXT, ingredients TEXT,'
        ' abv NUMERIC, ibu NUMERIC, srm NUMERIC, tasted INTEGER, my_vote INTEGER, comment TEXT, price TEXT,'
        ' ranking NUMERIC, votes NUMERIC, release TEXT, sell INTEGER, brewerId INTEGER, categoryId INTEGER)',
    'CREATE TABLE promotion(id INTEGER PRIMARY KEY AUTOINCREMENT, imageUri TEXT,'
        ' description TEXT, brewer_id INTEGER, '
        'FOREIGN KEY(brewer_id) REFERENCES brewer(id) ON DELETE CASCADE )',
    'CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, imageUri TEXT)',
  ];

  Future<Database> getDataBase() async {
    if (_database != null) {
      return _database;
    } else {
      _database = await getDatabasesPath().then((String path) async {
        String dbPath = join(path, 'craftbeerco.db');
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
      return _database;
    }
  }
}
