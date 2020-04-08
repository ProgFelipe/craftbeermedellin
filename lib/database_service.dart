import 'package:craftbeer/models.dart';
import 'package:craftbeer/api.dart';

class DataBaseService {

  ///Brewer
  Stream<List<Brewer>> streamBrewers() {
    return db.fetchBrewers().map((brewersList) =>
        brewersList.documents.map((brewer) => Brewer.fromMap(brewer)).toList());
  }

  Stream<List<Beer>> streamBeers() {
    return db.fetchBrewers().map((beers) =>
        beers.documents.map((beer) => Beer.fromMap(beer)).toList());
  }

  Stream<Brewer> streamBrewerByRef(String brewerRef) {
    return db.fetchBrewerByRef(brewerRef).map((beer) => Brewer.fromMap(beer));
  }

  Stream<List<BeerType>> streamBeerTypes() {
    return db.fetchBeerCategories().map((beerCategories) => beerCategories
        .documents
        .map((category) => BeerType.fromMap(category))
        .toList());
  }

  Stream<Beer> streamBeerByType(String beerRef) {
    return db.fetchBeerByReference(beerRef).map((beer) => Beer.fromMap(beer));
  }

  Stream<List<Beer>> fetchTopBeers() {
    return db.fetchTopBeers().map(
        (beers) => beers.documents.map((beer) => Beer.fromMap(beer)).toList());
  }

  /*List<Beer> fetchTopBeersFromBeers(List<Beer> beers) async {
    beers.sort((a,b){return a.ranking.compareTo(b.ranking);});
    return await beers.sublist(0, beers.length > 3 ? 4 : beers.length);
  }*/

  Future<void> futureSetVoteBeer(String brewerId, int vote) {
    return db.beerVote(brewerId, vote);
  }

  Stream<List<Event>> streamEvents() {
    return db.fetchEvents().map((events) =>
        events.documents.map((event) => Event.fromMap(event)).toList());
  }

  Stream<List<Promotion>> streamPromotions() {
    return db.fetchPromotions().map((promotions) => promotions.documents
        .map((promotion) => Promotion.fromMap(promotion))
        .toList());
  }
}
