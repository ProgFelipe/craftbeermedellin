import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String city, date, description, imageUri, name, eventLink;
  final Timestamp timestamp;
  final num longitude, latitude;

  Event(
      {this.city,
      this.date,
      this.timestamp,
      this.description,
      this.imageUri,
      this.name,
      this.eventLink,
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
        eventLink: data['event_link'] ?? '',
        longitude: data['longitude'] ?? -1.0,
        latitude: data['latitude'] ?? -1.0);
  }
}
