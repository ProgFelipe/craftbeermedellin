import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class BrewerDao{
  static const BREWER_TABLE = 'brewer';
  final beersDao = BeersDao();

  Future<void> insertBrewers(List<Brewer> brewers) async {
    final Database db = await DataBaseProvider().getDataBase();
    brewers.forEach((brewer) async {
      final List<Map<String, dynamic>> brewerMap = await db.query(BREWER_TABLE, where: "id = ?", whereArgs: [brewer.id]);
      if(brewerMap?.isEmpty ?? true) {
        await db.insert(
          BREWER_TABLE,
          brewer.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,);
      }else{
        Map<String, dynamic> brewerFromServer = brewer.toDbMap();
        brewerFromServer['favorite'] = brewerMap[0]['favorite'];
        await db.update(
            BREWER_TABLE,
            brewerFromServer,
            where: "id = ?",
            whereArgs: [brewer.id]);
      }

      await beersDao.insertBeers(brewer.beers);
    });
  }

  Future<List<Brewer>> getBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    final List<Map<String, dynamic>> brewersMap = await db.query(BREWER_TABLE);
    List<Brewer> brewers = List();
    brewersMap.forEach((brewer) async {
      var brewerObj = Brewer.fromDB(brewer);
      brewerObj.beers = await beersDao.getBeersByBrewer(brewerObj.id);
      brewers.add(brewerObj);
    });
    return brewers;
  }

  Future<void> deleteBrewers() async {
    final Database db = await DataBaseProvider().getDataBase();
    db.delete(BREWER_TABLE);
  }

  ///Favorites
  Future<bool> isFavorite(int brewerId) async {
    final Database db = await DataBaseProvider().getDataBase();
    List<Map<String, dynamic>> result = await db.query(BREWER_TABLE, where: "id = ?", whereArgs: [brewerId]);
    return result?.isEmpty ?? false;
  }

  Future<void> setFavorite(Brewer brewer) async {
    final Database db = await DataBaseProvider().getDataBase();
    await db.update(BREWER_TABLE, brewer.toDbMap(), where: "id = ?", whereArgs: [brewer.id]);
  }

}