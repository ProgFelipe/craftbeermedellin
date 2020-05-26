import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Api {
  final _fireStore = Firestore.instance;
  static final Api _singleton = Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  static const String brewers = 'brewers';
  static const String brewer = 'brewer';
  static const String beers = 'beers';
  static const String beerType = 'type';
  static const String name = 'name';
  static const String ranking = 'ranking';
  static const String brewName = 'name';
  static const String brewsReleases = 'brewingOn';
  static const String votes = 'votes';
  static const String releases = 'releases';
  static String events = 'events';
  static String promotions = 'promotions';

  ///BeerCategory
  Stream<QuerySnapshot> fetchBeerCategories() {
    debugPrint('***BEER BY CATEGORY**');
    return _fireStore.collection('beertypes').snapshots();
  }

  ///Vote
  Future<void> beerVote(String beerRef, int vote) async {
    debugPrint('VAMOS A VOTAR $beerRef, $vote');
    var document = _fireStore.collection(beers).document(beerRef);
    document.get().then((beer) {
      int numVotes = beer[votes];
      int currentRanking = beer[ranking];
      numVotes == null
          ? document.setData({votes: 1}, merge: true)
          : document.updateData({votes: numVotes + 1});
      currentRanking == null
          ? document.setData({ranking: vote}, merge: true)
          : document.updateData({ranking: currentRanking + vote});
    });
  }

  ///Releases
  Stream<QuerySnapshot> fetchReleases() {
    debugPrint('***Suscrito a top cervezas**');
    return _fireStore.collection(releases).limit(5).snapshots();
  }

  ///Beers
  Stream<QuerySnapshot> fetchBeers() {
    debugPrint('***Suscrito a cervezas**');
    return _fireStore.collection(beers).snapshots();
  }

  ///Brewers
  Stream<QuerySnapshot> fetchBrewers() {
    debugPrint('***BREWERS SERVICE SNAPSHOT**');
    return _fireStore.collection(brewers).snapshots();
  }

  ///Events
  Stream<QuerySnapshot> fetchEvents() {
    debugPrint('***Suscrito a EVENTS**');
    return _fireStore.collection(events).snapshots();
  }

  ///Promotions
  Stream<QuerySnapshot> fetchPromotions() {
    debugPrint('***Suscrito a PROMOTIONS**');
    return _fireStore.collection(promotions).snapshots();
  }
}

Api db = Api();
