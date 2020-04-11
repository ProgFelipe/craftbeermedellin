import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beer {
  final String id, name, description, history, brewerRef, imageUri, type;
  final num abv, ibu;
  final num ranking, votes;
  final Timestamp release;
  final bool sell;

  Beer(
      {this.id,
      this.name,
      this.brewerRef,
      this.description,
      this.history,
      this.abv,
      this.ibu,
      this.imageUri,
      this.ranking,
      this.votes,
      this.release,
      this.sell,
      this.type});

  factory Beer.fromMap(DocumentSnapshot data) {
    var beer = Beer(
        id: data?.documentID ?? '',
        name: data['name'] ?? '',
        brewerRef: data['brewer']?.documentID ?? '',
        description: data['description'] ?? '',
        history: data['history'] ?? '',
        abv: data['abv']?.toDouble() ?? 0.0,
        ibu: data['ibu']?.toDouble() ?? 0.0,
        imageUri: data['imageUri'] ?? '',
        ranking: data['ranking'] as num ?? 0,
        votes: data['votes'] ?? 0,
        release: data['release'] ?? null,
        sell: data['sell'] ?? false,
        type: data['type']?.documentID ?? '');
    return beer;
  }
}

class Brewer with ChangeNotifier {
  List<String> beersRef;
  List<Promotion> promotions;
  String id, description, imageUri, name, brewers, aboutUs, brewersImageUri;
  String phone, instagram, facebook, youtube, website;
  bool _stateIsFavorite;

  bool get stateIsFavorite => _stateIsFavorite;

  set stateIsFavorite(bool newValue) {
    if (stateIsFavorite != newValue) {
      _stateIsFavorite = newValue;
      changeFavoriteState(newValue);
      notifyListeners();
    }
  }

  Brewer(
      {this.id,
      this.beersRef,
      this.promotions,
      this.description,
      this.imageUri,
      this.name,
      this.brewers,
      this.brewersImageUri,
      this.aboutUs,
      this.phone,
      this.instagram,
      this.facebook,
      this.youtube,
      this.website});

  factory Brewer.fromMap(DocumentSnapshot data) {
    var brewer = Brewer(
      id: data.documentID,
      beersRef: data['beers']
              ?.map<String>(
                  (reference) => (reference as DocumentReference).documentID)
              ?.toList() ??
          [''],
      promotions: data['promos']
              ?.map<Promotion>((promotion) => Promotion.fromMap(promotion))
              ?.toList() ??
          [],
      description: data['description'] ?? '',
      imageUri: data['imageUri'] ?? '',
      name: data['name'] ?? '',
      brewers: data['brewers'] ?? '',
      aboutUs: data['about_us'] ?? '',
      brewersImageUri: data['brewers_imageUri'] != null
          ? data['brewers_imageUri']
          : data['imageUri'] ?? '',
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      facebook: data['facebook'] ?? '',
      youtube: data['youtube'] ?? '',
      website: data['website'] ?? '',
    );
    return brewer;
  }

  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  Future<bool> isFavorite() async {
    return getSharedPreference().then(
        (value) => (value.getStringList('favorites') ?? List()).contains(name));
  }

  void changeFavoriteState(bool newValue) async {
    SharedPreferences prefs = await getSharedPreference();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites?.contains(name);

    if (exist && !newValue) {
      favorites.remove(name);
    }
    if (!exist && newValue) {
      favorites.add(name);
    }
    favorites.forEach((element) {
      debugPrint('Favorite: $element');
    });
    await prefs.setStringList('favorites', favorites);
  }
}

class BeerType {
  DocumentReference id;
  String name, description, imageUri;
  List<String> beers;

  BeerType({this.id, this.name, this.description, this.imageUri, this.beers});

  factory BeerType.fromMap(DocumentSnapshot data) {
    return BeerType(
      id: data.reference,
      beers: data['beers']
              ?.map<String>((beerRef) => beerRef != null
                  ? (beerRef as DocumentReference).documentID
                  : null)
              ?.toList() ??
          List(0),
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUri: data['imageUri'] ?? '',
    );
  }
}

class Event {
  String city, date, description, imageUri, name;
  final Timestamp timestamp;

  Event(
      {this.city,
      this.date,
      this.timestamp,
      this.description,
      this.imageUri,
      this.name});

  factory Event.fromMap(DocumentSnapshot data) {
    return Event(
        city: data['city'] ?? '',
        date: data['date'] ?? '',
        timestamp: data['dateTime'] ?? null,
        description: data['description'] ?? '',
        imageUri: data['imageUri'] ?? '',
        name: data['name'] ?? '');
  }
}

class Promotion {
  String imageUri;
  String description;
  String brewerRef;

  Promotion({this.imageUri, this.description, this.brewerRef});

  factory Promotion.fromSnapshotMap(DocumentSnapshot data) {
    return Promotion(
      description: data['description'] ?? '',
      brewerRef: data['brewerRef'] ?? '',
      imageUri: data['imageUri'] ??
          'http://morganfields.com.sg/wp-content/uploads/img-home-promo3.jpg',
    );
  }

  factory Promotion.fromMap(Map data) {
    return Promotion(
      description: data['description'] ?? '',
      brewerRef: data['brewerRef'] ?? '',
      imageUri: data['imageUri'] ??
          'http://morganfields.com.sg/wp-content/uploads/img-home-promo3.jpg',
    );
  }
}

class Release {
  String name, imageUri;

  Release({this.name, this.imageUri});

  factory Release.fromMap(DocumentSnapshot data) {
    return Release(
      name: data['name'] ?? '',
      imageUri: data['imageUri'] ?? '',
    );
  }
}

class TopBeers {
  List<String> beersRef;

  TopBeers({this.beersRef});

  factory TopBeers.fromMap(DocumentSnapshot data) {
    return TopBeers(
      beersRef: data['beers'] ?? List<String>(),
    );
  }
}
