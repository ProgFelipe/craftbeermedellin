import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  String imageUri;
  String description;
  String brewerRef;

  Promotion({this.imageUri, this.description, this.brewerRef});

  factory Promotion.fromSnapshotMap(DocumentSnapshot data) {
    return Promotion(
      description: data['description'] ?? '',
      brewerRef: data['brewerRef'] ?? '',
      imageUri: data['imageUri'] ?? '',
    );
  }

  factory Promotion.fromMap(Map data) {
    return Promotion(
      description: data['description'] ?? '',
      brewerRef: data['brewerRef'] ?? '',
      imageUri: data['imageUri'] ?? '',
    );
  }
}