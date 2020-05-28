import 'package:flutter/cupertino.dart';

class Store {
  final String name;
  final bool parking, publicTransport, easyAccess;
  final String openHours;
  final double latitude, longitude;
  final String imageUrl;

  Store(
      {this.name,
      this.parking,
      this.publicTransport,
      this.easyAccess,
      this.openHours,
      this.latitude,
      this.longitude,
      this.imageUrl});

  factory Store.fromJson(Map<String, dynamic> data) {
    debugPrint('STORES====');
    debugPrint('$data');
    return Store(
        name: data['name'] ?? '',
        parking: data['parking'] ?? false,
        publicTransport: data['public_transport'] ?? false,
        easyAccess: data['easy_access'] ?? false,
        openHours: data['open_hours'] ?? '',
        latitude: double.parse(data['latitude']) ?? 0.0,
        longitude: double.parse(data['longitude']) ?? 0.0,
        imageUrl: data['image_url'] ?? '');
  }
}
