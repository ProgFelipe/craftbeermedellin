import 'package:craftbeer/api.dart';
import 'package:craftbeer/models.dart';

class DataBaseService {
  ///Brewer
  Stream<List<Brewer>> streamBrewers() {
    return db.fetchBrewers().map((brewersList) =>
        brewersList.documents.map((brewer) => Brewer.fromMap(brewer)).toList());
  }

  ///Brewer item
  Future<Brewer> futureBrewerByRef(
      List<Brewer> brewers, String brewerRef) async {
    return brewers.where((beer) => beer.id == brewerRef).first;
  }

  ///Beers
  Stream<List<Beer>> streamBeers() {
    return db.fetchBeers().map(
        (beers) => beers.documents.map((beer) => Beer.fromMap(beer)).toList());
  }

  ///Beer item
  Future<Beer> futureBeerByReference(List<Beer> beers, String beerRef) async {
    return beers.where((element) => element.id == beerRef).first;
  }

  ///Top Beers
  Future<List<Beer>> fetchTopBeers(List<Beer> beers) async {
    beers.sort((a, b) => a.ranking.compareTo(b.ranking));
    return beers.sublist(0, beers.length >= 5 ? 5 : beers.length);
  }

  ///Vote
  Future<void> futureSetVoteBeer(String brewerId, int vote) {
    return db.beerVote(brewerId, vote);
  }

  ///RELEASES
  Stream<List<Release>> fetchReleases() {
    return db.fetchReleases().map((releases) =>
        releases.documents.map((release) => Release.fromMap(release)).toList());
  }

  ///EVENTS
  Stream<List<Event>> streamEvents() {
    return db.fetchEvents().map((events) =>
        events.documents.map((event) => Event.fromMap(event)).toList());
  }

  ///PROMOTIONS
  Stream<List<Promotion>> streamPromotions() {
    return db.fetchPromotions().map((promotions) => promotions.documents
        .map((promotion) => Promotion.fromSnapshotMap(promotion))
        .toList());
  }

  ///Beer type - Categories
  Stream<List<BeerType>> streamBeerTypes() {
    return db.fetchBeerCategories().map((beerCategories) => beerCategories
        .documents
        .map((category) => BeerType.fromMap(category))
        .toList());
  }
}
