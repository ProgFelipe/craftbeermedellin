import 'package:craftbeer/models.dart';
import 'package:craftbeer/repository/api.dart';

class DataBaseService {
  Stream<List<Brewer>> streamBrewers() {
    return db.fetchBrewers().map((brewersList) =>
        brewersList.documents.map((brewer) => Brewer.fromMap(brewer)).toList());
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
