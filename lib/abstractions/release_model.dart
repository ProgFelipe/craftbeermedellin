import 'package:cloud_firestore/cloud_firestore.dart';

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