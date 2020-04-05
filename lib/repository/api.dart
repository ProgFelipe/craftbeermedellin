import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

//https://medium.com/@aaron_lu1/firebase-cloud-firestore-add-set-update-delete-get-data-6da566513b1b
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
  static const String ibu = 'ibu';
  static const String abv = 'abv';
  static const String votes = 'votes';

  ///Beer Categories

  ///Brewers
  Stream<QuerySnapshot> fetchBrewers() {
    debugPrint('--BREWERS SERVICE SNAPSHOT--');
    return _fireStore.collection(brewers).snapshots();
  }

  ///Brewer Detail -> Brewer
  Stream<DocumentSnapshot> fetchBrewer(String brewerRef) {
    debugPrint('Collection /brewers/$brewerRef');
    return _fireStore.collection(brewers).document(brewerRef).snapshots();
  }

  ///BeerCategory
  Stream<QuerySnapshot> fetchBeerCategories(){
    return _fireStore.collection('beertypes').snapshots();
  }
  Stream<DocumentSnapshot> fetchBeerByReference(String beerRef) {
    return _fireStore.collection(beers).document(beerRef).snapshots();
  }

  Stream<QuerySnapshot> fetchBrewerByName(String brewerName) {
    return _fireStore
        .collection(brewer)
        .where(name, isEqualTo: brewerName)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchBrewerBeers(String brewerDocumentRef) {
    return _fireStore
        .collection(beers)
        .where(brewer, isEqualTo: '/$brewers/$brewerDocumentRef')
        .snapshots();
  }

  Future<int> getBrewerVotes(String brewerName) {
    return _fireStore
        .collection(brewers)
        .document(brewerName)
        .get()
        .then((doc) {
      if (doc.exists) {
        return doc.data[ranking];
      } else {
        debugPrint("No such document!");
        return 0;
      }
    });
  }

  Future<void> brewerVote(String brewerName) async {
    int currentRanking;
    getBrewerVotes(brewerName).then((value) => currentRanking = value);
    _fireStore
        .collection(brewers)
        .document(brewerName)
        .updateData({ranking: currentRanking + 1});
  }

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

  List<DocumentSnapshot> documents;
  Future<List<DocumentSnapshot>> searchBeers(String query) async {
    if (documents == null || documents.isEmpty) {
      await _fireStore
          .collection(beers)
          .getDocuments()
          .then((value) => documents = value.documents);
      await _fireStore
          .collection(brewers)
          .getDocuments()
          .then((value) => documents..addAll(value.documents));
    }
    List<DocumentSnapshot> documentList = List();
    documentList = documents.where((doc) {
      debugPrint('Searching ${doc.data['name']}');
      return doc['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return documentList;
  }

  //Home
  Stream<QuerySnapshot> fetchTopBeers() {
    debugPrint('Suscrito a top cervezas');
    return _fireStore
        .collection(beers)
        .orderBy('ranking', descending: true)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchReleases() {
    debugPrint('Suscrito a releases cervezas');
    var currentDate = DateTime.now();
    DateTime _starDate = DateTime(
        currentDate.year, currentDate.month - 1, currentDate.day, 0, 0);
    debugPrint("Release from ${_starDate.month}-${_starDate.day}");
    return _fireStore
        .collection(beers)
        .where('release', isGreaterThanOrEqualTo: _starDate)
        .orderBy('release', descending: true)
        .limit(5)
        .snapshots();
  }

  ///Events
  static String events = 'events';
  Stream fetchEvents() => _fireStore.collection(events).snapshots();

  ///Promotions
  static String promotions = 'promotions';
  Stream fetchPromotions() => _fireStore.collection(promotions).snapshots();

  ///Categories
  Stream fetchBeersByType(String categoryRef) {
    debugPrint('Beer of type ${'/beertypes/$categoryRef'}');
    return _fireStore
        .collection(beers)
        .where(beerType, isEqualTo: '/beertypes/$categoryRef')
        .snapshots();
  }
}

Api db = Api();
