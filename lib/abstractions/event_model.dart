import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String city, date, description, imageUri, name;
  final Timestamp timestamp;
  String longitude, latitude;

  Event(
      {this.city,
      this.date,
      this.timestamp,
      this.description,
      this.imageUri,
      this.name,
      this.longitude,
      this.latitude});

  factory Event.fromMap(DocumentSnapshot data) {
    return Event(
        city: data['city'] ?? '',
        date: data['date'] ?? '',
        timestamp: data['dateTime'] ?? null,
        description: data['description'] ?? '',
        imageUri: data['imageUri'] ?? '',
        name: data['name'] ?? '',
        longitude: data['longitude'] ?? '',
        latitude: data['latitude'] ?? '');
  }
}
