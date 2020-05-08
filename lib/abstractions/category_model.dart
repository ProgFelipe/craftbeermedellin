import 'package:cloud_firestore/cloud_firestore.dart';

class BeerType {
  DocumentReference id;
  String name, imageUri;
  List<int> beersIds;

  BeerType({this.id, this.name, this.imageUri, this.beersIds});

  factory BeerType.fromJson(Map<String, dynamic> data) {
    return BeerType(
        name: data['name'] ?? '',
        beersIds: data['category_beers']
                .map<int>((id) => id['id'] as int)
                ?.toList() ??
            List(),
        imageUri: data['category_pic'] ?? '');
  }
}
