import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class BeersDao{

  Future<void> insertBeers(List<Beer> beers) async {
    final Database db = await DataBaseProvider().getDataBase();
    beers.forEach((beer) async {
      await db.insert(
        'beer',
        beer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,);
    });
  }

  Future<List<Brewer>> getBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> brewersMap = await db.query('brewers');
    List<Brewer> brewers = List();
    brewersMap.forEach((brewer) {
      brewers.add(Brewer.fromJson(brewer));
    });
    return brewers;
  }

  Future<void> deleteBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    db.delete('brewers');
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