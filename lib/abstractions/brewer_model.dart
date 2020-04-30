import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Brewer with ChangeNotifier {
  List<Promotion> promotions;
  int id;
  String name;
  List<Beer> beers;
  String description, imageUri, aboutUs, brewersImageUri;
  String phone, instagram, facebook, youtube, website;
  bool _stateIsFavorite = false;
  bool canSale = false;

  bool get stateIsFavorite => _stateIsFavorite;

  set stateIsFavorite(bool newValue) {
    if (stateIsFavorite != newValue) {
      _stateIsFavorite = newValue;
      changeFavoriteState(newValue);
      notifyListeners();
    }
  }

  Brewer(
      {this.id,
        this.beers,
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
      description: data['description'] ?? '',
      imageUri: data['profile_pic'] ?? '',
      name: data['name'] ?? '',
      aboutUs: data['about_us'] ?? '',
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      facebook: data['facebook'] ?? '',
      youtube: data['youtube'] ?? '',
      website: data['website'] ?? '',
      canSale: data['on_sale'] ?? false,
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
      'canSale' : canSale ? 1 : 0
    };
  }

  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  Future<bool> isFavorite() async {
    return getSharedPreference().then(
            (value) => (value.getStringList('favorites') ?? List()).contains(name));
  }

  void changeFavoriteState(bool newValue) async {
    SharedPreferences prefs = await getSharedPreference();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites?.contains(name);

    if (exist && !newValue) {
      favorites.remove(name);
    }
    if (!exist && newValue) {
      favorites.add(name);
    }
    favorites.forEach((element) {
      debugPrint('Favorite: $element');
    });
    await prefs.setStringList('favorites', favorites);
  }
}