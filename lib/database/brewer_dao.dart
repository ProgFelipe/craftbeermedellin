import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class BrewerDao {
  static const BREWER_TABLE = 'brewer';
  final beersDao = BeersDao();

  Future<void> insertBrewers(List<Brewer> brewers) async {
    debugPrint('INSERTAMOS CERVECEROS ${brewers.length}');
    final Database db = await DataBaseProvider().getDataBase();

    Batch batch = db.batch();
    batch.delete(BREWER_TABLE);

    List<Beer> beers = List();
    //Current Favorite Brewers
    final List<Map<String, dynamic>> favoriteBrewers =
    await db.query(BREWER_TABLE, where: "favorite = ?", whereArgs: [1]);

    brewers.forEach((brewer){
      Map<String, dynamic> brewerFromServer = brewer.toDbMap();
      if (favoriteBrewers?.isNotEmpty ?? false) {
        var result = favoriteBrewers.firstWhere((element) => element['id'] == brewer.id, orElse: () => null);
        if(result != null) {
          brewerFromServer['favorite'] = 1;
        }
      }
      batch.insert(
        BREWER_TABLE,
        brewerFromServer,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      //Beers from Current Brewer
      if(brewer.beers != null && brewer.beers.isNotEmpty) {
        debugPrint("Cervezas DEL SERVICIO ${brewer.beers.length}");
        beers.addAll(brewer.beers);
      }
    });
    batch.commit(noResult: true);

    debugPrint("Cervezas PARA INSERTAR ${beers.length}");
    await beersDao.insertBeers(beers);
  }

  Future<List<Brewer>> getBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> brewersMap = await db.query(BREWER_TABLE);
    List<Brewer> brewers = List();

    for (var brewer in brewersMap) {
      var brewerObj = Brewer.fromDB(brewer);
      brewerObj.beers = await beersDao.getBeersByBrewer(brewerObj.id);
      brewers.add(brewerObj);
    }
    return brewers;
  }

  Future<void> deleteBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    db.delete(BREWER_TABLE);
  }

  ///Favorites
  Future<bool> isFavorite(int brewerId) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Map<String, dynamic>> result =
        await db.query(BREWER_TABLE, where: "id = ?", whereArgs: [brewerId]);
    return result?.isEmpty ?? false;
  }

  Future<Brewer> fetchBrewerById(int brewerId) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Map<String, dynamic>> result =
        await db.query(BREWER_TABLE, where: "id = ?", whereArgs: [brewerId]);
    Brewer brewer = Brewer.fromDB(result.first);
    brewer.beers = await beersDao.getBeersByBrewer(brewerId);
    return brewer;
  }

  Future<void> setFavorite(Brewer brewer) async {
    final Database db = await DataBaseProvider().getDataBase();
    await db.update(BREWER_TABLE, brewer.toDbMap(),
        where: "id = ?", whereArgs: [brewer.id]);
  }
}
