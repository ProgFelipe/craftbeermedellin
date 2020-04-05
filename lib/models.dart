import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Beer {
  final String id;
  final String name, description, history;
  final double abv, ibu;
  final String brewerRef;
  final String imageUri;
  final int ranking, votes;
  final Timestamp release;
  final bool sell;
  final BeerType type;

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
    return Beer(
        id: data.documentID,
        name: data['name'],
        brewerRef: data['brewer']
                ?.map<String>(
                    (reference) => (reference as DocumentReference).documentID)
                ?.toList() ??
            [''],
        description: data['description'],
        history: data['history'] ?? '',
        abv: data['abv'] ?? 0.0,
        ibu: data['ibu'] ?? 0.0,
        imageUri: data['imageUri'] ?? '',
        ranking: data['ranking'] ?? 0,
        votes: data['votes'] ?? 0,
        release: data['release'] ?? Timestamp.now(),
        sell: data['sell'] ?? false,
        type: data['type']);
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
    debugPrint('--BREWER INITIAL PARSE---');

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
    debugPrint('BEERS LENGHT ${brewer.beersRef.length}');
    return brewer;
  }
}

class BeerType {
  String name, description, imageUri;
  BeerType({this.name, this.description, this.imageUri});

  factory BeerType.fromMap(DocumentSnapshot data) {
    return BeerType(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUri: data['imageUri'] ?? '',
    );
  }
}

class Event {
  String city, date, description, imageUri, name;
  Event({this.city, this.date, this.description, this.imageUri, this.name});

  factory Event.fromMap(DocumentSnapshot data) {
    return Event(
        city: data['city'] ?? '',
        date: data['date'] ?? '',
        description: data['description'] ?? '',
        imageUri: data['imageUri'] ?? '',
        name: data['name'] ?? '');
  }
}

class Promotions {
  String imageUri;
  Promotions({this.imageUri});

  factory Promotions.fromMap(DocumentSnapshot data) {
    return Promotions(
      imageUri: data['imageUri'] ?? '',
    );
  }
}

/**
 * Get document avoiding searching all beers for release date
 */
class Releases {
  List<String> beersRef;
  Releases({this.beersRef});

  factory Releases.fromMap(DocumentSnapshot data) {
    return Releases(
      beersRef: data['beers'] ?? List<String>(),
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
