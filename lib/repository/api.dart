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
  static const String name = 'name';
  static const String ranking = 'ranking';
  static const String brewName = 'name';
  static const String brewsReleases = 'brewingOn';
  static const String ibu = 'ibu';
  static const String abv = 'abv';

  ///Beer Categories

  ///Brewers
  Stream<QuerySnapshot> fetchBrewers() =>
      _fireStore.collection(brewers).snapshots();

  ///Brewer Detail -> Brewer
  Stream<DocumentSnapshot> fetchBrewer(String brewerRef) {
    debugPrint('Collection /brewers/$brewerRef');
    return _fireStore.collection(brewers).document(brewerRef).snapshots();
    /*.where(name, isEqualTo: brewerName)
        .limit(1)
        .getDocuments()
        .then((querySnapshot) {
      debugPrint('SNAPSHOT $querySnapshot');
      if (querySnapshot != null) {
        var result = querySnapshot.documents[0];
        debugPrint('Encontramos este document $result');
        debugPrint('Encontramos este document ${result.data}');
        return result;
      } else {
        debugPrint('NO ENCONTRAMOS este document null');
        return null;
      }
    }).asStream();*/
  }

  Stream<QuerySnapshot> fetchBrewerBeers(String brewerDocumentRef) {
    debugPrint('Beers route: ${'/$brewer/$brewerDocumentRef'}');
    return _fireStore
        .collection(beers)
        .where(brewer, isEqualTo: '/$brewers/$brewerDocumentRef')
        .snapshots();
  }

  Future<int> getBrewerVotes(String brewerName) {
    _fireStore.collection(brewers).document(brewerName).get().then((doc) {
      if (doc.exists) {
        return doc.data[ranking];
      } else {
        debugPrint("No such document!");
        return -1;
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

  Future<void> beerVote(String brewerName, String password) async {
    //Brewer -> Beer -> increase vote
    _fireStore
        .collection(brewers)
        .where(name, isEqualTo: brewerName)
        .getDocuments()
        .then((doc) {
      if (doc != null) {}
    });
    //.setData({'email': email, 'password': password, 'goalAdded': false});
  }

  ///Events
  static String events = 'events';
  Stream fetchEvents() => _fireStore.collection(events).snapshots();

  ///Promotions
  static String promotions = 'promotions';
  Stream fetchPromotions() => _fireStore.collection(promotions).snapshots();
}

Api db = Api();
