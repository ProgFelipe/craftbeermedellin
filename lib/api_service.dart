import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/abstractions/release_model.dart';
import 'package:craftbeer/api.dart';
import 'package:http/http.dart' as http;

class DataBaseService {
  //final String BASE_URL = "http://127.0.0.1:8000/api";
  static const String BASE_URL = "https://craftbeerco.herokuapp.com/api";

  Future<http.Response> fetchBrewers() async =>
      await http.get('$BASE_URL/brewer/?format=json');

  Future<http.Response> fetchBeerTypes() async =>
      await http.get('$BASE_URL/categories/?format=json');

  Future<http.Response> fetchArticles() async =>
      await http.get('$BASE_URL/articles/?format=json');

  Future<http.Response> fetchStores() async =>
      await http.get('$BASE_URL/places/?format=json');

  ///Brewer item
  Future<Brewer> futureBrewerByID(List<Brewer> brewers, int brewerID) async {
    return brewers.where((brewer) => brewer.id == brewerID).first;
  }

  /*///Vote
  Future<void> futureSetBeerFeedback(int userId, int brewerId, int beerId, int vote, String comment) {
    //return db.beerVote(brewerId, vote);
  }*/

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
}
