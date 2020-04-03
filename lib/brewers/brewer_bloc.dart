import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/bloc_provider.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:craftbeer/repository/brewer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrewerBloc implements BlocBase {
  final String brewerRef;
  BrewerBloc({this.brewerRef});

  int CallCounter = 0;
  /**
   * var controller = StreamController<num>();

      // Create StreamTransformer with transformer closure
      var streamTransformer = StreamTransformer<num, num>.fromHandlers(
      handleData: (num data, EventSink sink) {
      sink.add(data * 2);
      },
      handleError: (error, stacktrace, sink) {
      sink.addError('Something went wrong: $error');
      },
      handleDone: (sink) {
      sink.close();
      },
      );

      // Call the `transform` method on the controller's stream
      // while passing in the stream transformer
      var controllerStream = controller.stream.transform(streamTransformer);

      // Just print out transformations to the console
      controllerStream.listen(print);

      // Add data to stream to see transformations in effect
      controller.sink.add(1); // 2
      controller.sink.add(2); // 4
      controller.sink.add(3); // 6
      controller.sink.add(4); // 8
      controller.sink.add(5); // 10
   */
  final _brewerController = StreamController<Brewer>();
  Stream<Brewer> get brewerStream => _brewerController.stream;

  /*@override
  void dispose() {
    _brewerController.close();
  }*/

  Stream<DocumentSnapshot> fetchBrewer() => db.fetchBrewer(brewerRef);

  String getBrewerName(AsyncSnapshot documentSnapshot) {
    return documentSnapshot.data['name'] ?? '';
  }

  String getBrewerDescription(AsyncSnapshot documentSnapshot) {
    return documentSnapshot.data['description'] ?? '';
  }

  Stream<QuerySnapshot> fetchBeers(String brewerDocumentRef) =>
      db.fetchBrewerBeers(brewerDocumentRef);

  String getLogo(AsyncSnapshot snapshot) {
    return snapshot.data['imageUri'];
  }

  String getPhone(AsyncSnapshot documentSnapshot) {
    return documentSnapshot.data['phone'];
  }

  List<DocumentSnapshot> getBeers(AsyncSnapshot snapshot) {
    //return snapshot.data.documents[item][brewsReleases];
  }

  Stream<DocumentSnapshot> getBeer(String beerRef) {
    return db.fetchBeerByReference(beerRef);
    //return snapshot.data.documents[item]
    //[brewsReleases][index];
  }

  String getBeerName(AsyncSnapshot snapshot) {
    return snapshot.data.documents['name'] ?? 'Not found';
    //[brewsReleases][index];
    //[brewName] ??
    //    ''

    ///return snapshot.data.documents[item][brewsReleases][index][brewName];
  }

  String getIbu(AsyncSnapshot snapshot, int index) {
    //snapshot.data.documents[item][brewsReleases][index][ibu]?? ''
  }

  String getAbv(DocumentSnapshot documentSnapshot, int index) {
    //return documentSnapshot
    //snapshot.data.documents[item][brewsReleases][index][abv]?? ''
  }

  Future<bool> isFavorite(brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('favorites') ?? List()).contains(brewerName);
  }

  changeFavorite(bool isFavorite, String brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites != null ?? favorites.contains(brewerName);
    isFavorite ? favorites.remove(brewerName) : favorites.add(brewerName);
    print('Brewer is favorite: $exist ?.');
    await prefs.setStringList('favorites', favorites);
  }

  Color fetchBeerColor(String type) {
    switch (type.toLowerCase()) {
      case 'ipa':
        return Colors.orange;
      case 'pale ale':
        return Colors.orange[500];
      case 'stout':
        return Colors.brown[700];
      case 'pilsen':
        return Colors.yellow[500];
      case 'porter':
        return Colors.black54;
      case 'amber':
        return Colors.orange[400];
      case 'doppelbock':
        return Colors.brown;
      case 'bock':
        return Colors.yellow[300];
      case 'dunkel':
        return Colors.brown[700];
      case 'marzen':
        return Colors.orange[200];
      case 'raunchbier':
        return Colors.orangeAccent;
      case 'weizenbier':
        return Colors.yellow[600];
      case 'weizenbock':
        return Colors.brown[400];
      case 'kÖlsh':
        return Colors.yellow;
      default:
        return Colors.orange;
    }
  }

  @override
  void dispose() {
    _brewerController.close();
  }
}
