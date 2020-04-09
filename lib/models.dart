import 'package:cloud_firestore/cloud_firestore.dart';

class Beer {
  final String id;
  final String name;
  final String description;
  final String history;
  final num abv, ibu;
  final String brewerRef;
  final String imageUri;
  final num ranking, votes;
  final Timestamp release;
  final bool sell;
  final String type;

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

class Brewer {
  List<String> beersRef;
  String id,
      description,
      imageUri,
      name,
      phone,
      instagram,
      facebook,
      youtube,
      website;

  Brewer(
      {this.id,
      this.beersRef,
      this.description,
      this.imageUri,
      this.name,
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
      description: data['description'] ?? '',
      imageUri: data['imageUri'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      facebook: data['facebook'] ?? '',
      youtube: data['youtube'] ?? '',
      website: data['website'] ?? '',
    );
    return brewer;
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

  Promotion({this.imageUri});

  factory Promotion.fromMap(DocumentSnapshot data) {
    return Promotion(
      imageUri: data['imageUri'] ??
          'http://morganfields.com.sg/wp-content/uploads/img-home-promo3.jpg',
    );
  }
}

class Release {
  String name;
  String imageUri;

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
