import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class BeersDao{
  static const BEER_TABLE = 'beer';

  Future<void> insertBeers(List<Beer> beers) async {
    final Database db = await DataBaseProvider().getDataBase();
    beers.forEach((beer) async {
      await db.insert(
        BEER_TABLE,
        beer.toDaoMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,);
    });
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
    final List<Map<String, dynamic>> beersMap = await db.query(BEER_TABLE, where: "brewerId = ?", whereArgs: [brewerID] );
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

  ///Favorites
  Future<void> addBrewerToFavorite(int brewerId) async {
    final Database db = await DataBaseProvider().getDataBase();
    if(! await isFavorite(brewerId)){
      await db.insert('favoritbrewers', {'id' : brewerId} , conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> removeFromFavorite(int brewerId) async{
    final Database db = await DataBaseProvider().getDataBase();
    if(await isFavorite(brewerId)) {
      db.delete('favoritbrewers', where: "id = ?", whereArgs: [brewerId]);
    }
  }

  Future<bool> isFavorite(int brewerId) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Map<String, dynamic>> result = await db.query('favoritbrewers', where: "id = ?", whereArgs: [brewerId]);
    return result?.isEmpty ?? false;
  }
}