import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class BeersDao{
  static const BEER_TABLE = 'beer';

  Future<void> insertBeers(List<Beer> beers) async {
    final Database db = await DataBaseProvider().getDataBase();
    beers.forEach((beer) async {
      final List<Map<String, dynamic>> beerMap = await db.query(BEER_TABLE, where: "id = ?", whereArgs: [beer.id]);
      if(beerMap?.isEmpty ?? true){
        await db.insert(
          BEER_TABLE,
          beer.toDaoMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,);
      }else{
        Map<String, dynamic> beerFromServer = beer.toDaoMap();
        beerFromServer['tasted'] = beerMap[0]['tasted'];
        await db.update(
          BEER_TABLE,
          beerFromServer,
          where: "id = ?",
          whereArgs: [beer.id],);
      }
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


  Future<List<Beer>> getBeersFromCategory(List<int> beerIds) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Beer> beers = List();

    for(var id in beerIds){
      final List<Map<String, dynamic>> beersMap = await db.query(BEER_TABLE, where: "id = ?", whereArgs: [id] );
      var beer = beersMap.first;
      beers.add(Beer.fromDB(beer));
    }
    
    return beers;
  }

  Future<List<Beer>> getMyTastedBeers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> beersMap = await db.query(BEER_TABLE, where: "tasted = ?", whereArgs: [1] );
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
    await db.update(BEER_TABLE, beer.toDaoMap(), where: "id = ?", whereArgs: [beer.id]);
  }
}