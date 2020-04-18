import 'dart:convert';

import 'package:craftbeer/api.dart';
import 'package:craftbeer/models.dart';
import 'package:http/http.dart' as http;

class DataBaseService {
  final String BASE_URL = "http://127.0.0.1:8000/api";

  ///Brewer
  ///TODO REMOVE
  Stream<List<Brewer>> streamBrewers() {
    return db
        .fetchBrewers()
        .map((brewersList) =>
        brewersList.documents.map((brewer) {
          var brewerObj = Brewer.fromMap(brewer);
          brewerObj.isFavorite().then((value) {
            brewerObj.stateIsFavorite = value;
          });
          return brewerObj;
        }).toList());
  }

  Future<List<Brewer>> fetchBrewers() async {
    final response =
    await http.get('$BASE_URL/brewer/?format=json');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Brewer> brewers = List();
      for (Map brewer in jsonData) {
        brewers.add(Brewer.fromJson(brewer));
      }
      return brewers;
    }
    return null;

  }
  ///Brewer item
  Future<Brewer> futureBrewerByRef(List<Brewer> brewers,
      String brewerRef) async {
    return brewers
        .where((beer) => beer.id == brewerRef)
        .first;
  }

  ///Beers
  ///TODO REMOVE
  Stream<List<Beer>> streamBeers() {
    return db.fetchBeers().map(
            (beers) =>
            beers.documents.map((beer) => Beer.fromMap(beer)).toList());
  }

  Future<List<Beer>> fetchBeers() async {
    final response =
    await http.get('$BASE_URL/beers/?format=json');
    //[beer1, beer2, beer3, ...]
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      //var beers = jsonData.map((beer){Beer.fromJson(beer);}).toList();
      List<Beer> beers = List();
      for (Map beer in jsonData) {
        beers.add(Beer.fromJson(beer));
      }
      return beers;
    }
    return null;
  }

  ///Beer item
  //TODO REMOVE
  Future<Beer> futureBeerByReference(List<Beer> beers, String beerRef) async {
    return beers
        .where((element) => element.id == beerRef)
        .first;
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
    return db.fetchPromotions().map((promotions) =>
        promotions.documents
            .map((promotion) => Promotion.fromSnapshotMap(promotion))
            .toList());
  }

  ///Beer type - Categories
  ///TODO REMOVE
  Stream<List<BeerType>> streamBeerTypes() {
    return db.fetchBeerCategories().map((beerCategories) =>
        beerCategories
            .documents
            .map((category) => BeerType.fromMap(category))
            .toList());
  }

  Future<List<BeerType>> fetchBeerTypes() async {
    final response =
    await http.get('$BASE_URL/categories/?format=json');
    //[beer1, beer2, beer3, ...]
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      //var beers = jsonData.map((beer){Beer.fromJson(beer);}).toList();
      List<BeerType> beerTypes = List();
      for (Map beerType in jsonData) {
        beerTypes.add(BeerType.fromJson(beerType));
      }
      return beerTypes;
    }
    return null;
  }
}
