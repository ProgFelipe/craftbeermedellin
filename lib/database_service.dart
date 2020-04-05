import 'package:craftbeer/models.dart';
import 'package:craftbeer/repository/api.dart';

class DataBaseService {
  Stream<List<Brewer>> streamBrewers() {
    return db.fetchBrewers().map((brewersList) =>
        brewersList.documents.map((brewer) => Brewer.fromMap(brewer)).toList());
  }

  Stream<List<BeerType>> streamBeerTypes() {
    return db.fetchBeerCategories().map((beerCategories) =>
        beerCategories.documents.map((category) => BeerType.fromMap(category)).toList());
  }
}
