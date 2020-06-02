import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class BeersDao {
  static const BEER_TABLE = 'beer';

  Future<void> insertBeers(List<Beer> beers) async {
    final Database db = await DataBaseProvider().getDataBase();
    debugPrint('INSERTAMOS CERVEZAS ${beers.length}');

    Batch batch = db.batch();
    batch.delete(BEER_TABLE);

    final List<Map<String, dynamic>> tastedBeers =
        await db.query(BEER_TABLE, where: "tasted = ?", whereArgs: [1]);

    beers.forEach((beer) {
      var beerDbMap = beer.toDaoMap();
      if (tastedBeers?.isNotEmpty ?? false) {
        var beerTasted = tastedBeers.firstWhere(
            (element) => element['id'] == beer.id,
            orElse: () => null);
        if (beerTasted != null) {
          beerDbMap['tasted'] = 1;
        }
      }
      batch.insert(
        BEER_TABLE,
        beerDbMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Beer>> getBeers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> beersMap = await db.query(BEER_TABLE);
    List<Beer> beers = List();
    beersMap.forEach((beer) {
      beers.add(Beer.fromDB(beer));
    });
    return beers;
  }

  Future<List<Beer>> getBeersByBrewer(int brewerID) async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> beersMap = await db
        .query(BEER_TABLE, where: "brewerId = ?", whereArgs: [brewerID]);
    List<Beer> beers = List();
    beersMap.forEach((beer) {
      beers.add(Beer.fromDB(beer));
    });
    return beers;
  }

  Future<List<Beer>> getBeersFromCategory(List<int> beerIds) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Beer> beers = List();

    for (var id in beerIds) {
      final List<Map<String, dynamic>> beersMap =
          await db.query(BEER_TABLE, where: "id = ?", whereArgs: [id]);
      var beer = beersMap.first;
      beers.add(Beer.fromDB(beer));
    }

    return beers;
  }

  Future<List<Beer>> getMyTastedBeers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> beersMap =
        await db.query(BEER_TABLE, where: "tasted = ?", whereArgs: [1]);
    List<Beer> beers = List();
    beersMap.forEach((beer) {
      beers.add(Beer.fromDB(beer));
    });
    return beers;
  }

  Future<void> deleteBeers() async {
    final Database db = await DataBaseProvider().getDataBase();
    db.delete(BEER_TABLE);
  }

  Future<void> updateBeer(Beer beer) async {
    final Database db = await DataBaseProvider().getDataBase();
    await db.update(BEER_TABLE, beer.toDaoMap(),
        where: "id = ?", whereArgs: [beer.id]);
  }
}