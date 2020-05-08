import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:flutter/material.dart';

class Brewer with ChangeNotifier {
  List<Promotion> promotions;
  int id;
  String name;
  List<Beer> beers;
  String description, imageUri, aboutUs, brewersImageUri;
  String phone, instagram, facebook, youtube, website;
  bool canSale = false;
  bool favorite;

  Brewer(
      {this.id,
        this.beers,
        this.favorite,
        this.promotions,
        this.description,
        this.imageUri,
        this.name,
        this.brewersImageUri,
        this.aboutUs,
        this.phone,
        this.instagram,
        this.facebook,
        this.youtube,
        this.website,
        this.canSale});

  factory Brewer.fromJson(Map<String, dynamic> data) {
    var brewer = Brewer(
      id: data['id'],
      beers: data['beers']?.map<Beer>((beer) => Beer.fromJson(beer))?.toList() ?? [],
/*      promotions: data['promos']
          ?.map<Promotion>((promotion) => Promotion.fromMap(promotion))
          ?.toList() ??
          [],*/
      favorite: false,
      description: data['description'] ?? '',
      imageUri: data['profile_pic'] ?? '',
      name: data['name'] ?? '',
      aboutUs: data['about_us'] ?? '',
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      facebook: data['facebook'] ?? '',
      youtube: data['youtube'] ?? '',
      website: data['website'] ?? '',
      canSale: data['can_sale'] ?? false,
    );
    return brewer;
  }

  factory Brewer.fromDB(Map<String, dynamic> data) {
    var brewer = Brewer(
      id: data['id'],
      description: data['description'] ?? '',
      imageUri: data['imageUri'] ?? '',
      name: data['name'] ?? '',
      favorite: data['favorite']==1 ? true : false,
      aboutUs: data['about_us'] ?? '',
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      facebook: data['facebook'] ?? '',
      youtube: data['youtube'] ?? '',
      website: data['website'] ?? '',
      canSale: data['can_sale'] == 1 ? true : false,
    );
    return brewer;
  }


  Map<String, dynamic> toDbMap() {
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'imageUri' : imageUri,
      'aboutUs' : aboutUs,
      'phone' : phone,
      'instagram' : instagram,
      'facebook' : facebook,
      'youtube' : youtube,
      'website' : website,
      'favorite' : favorite ? 1 : 0,
      'can_sale' : canSale ? 1 : 0
    };
  }


  set updateFavorite(bool newValue) {
    favorite = newValue;
    notifyListeners();
  }

}