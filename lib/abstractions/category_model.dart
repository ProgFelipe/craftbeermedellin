import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryBeer {
  String name, imageUri;
  int brewerId;

  CategoryBeer({this.name, this.imageUri, this.brewerId});

  factory CategoryBeer.fromJson(Map<String, dynamic> data) {
    return CategoryBeer(
        name: data['name'] ?? '',
        brewerId: data['brewer'] ?? -1,
        imageUri: data['beer_pic'] ?? 'assets/beer.png');
  }
}

class BeerType {
  DocumentReference id;
  String name, description, imageUri;
  List<CategoryBeer> beers;

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

  factory BeerType.fromJson(Map<String, dynamic> data) {
    return BeerType(
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        beers: data['category_beers']
            .map<CategoryBeer>((beer) => CategoryBeer.fromJson(beer))
            .toList() ??
            '',
        imageUri: data['category_pic'] ?? '');
  }
}