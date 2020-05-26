import 'dart:async';

import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/brewer_dao.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BrewersData extends BaseProvider {
  static const CACHE_TIME_IN_DAYS = 3;

  List<Brewer> brewers = List();
  List<Beer> beers = List();
  Brewer currentBrewer;
  List<Beer> tastedBeers = List();
  bool brewerTakenFromDB = false;
  int tryAgainSeconds = 5;

  final api = Api();
  final brewerDAO = BrewerDao();
  final beersDAO = BeersDao();

  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  BrewersData() {
    getBrewers();
  }

  Future<void> getBrewers() async {
    try {
      showLoading();
      if (brewers.isEmpty) {
        debugPrint('TOMANDO DATOS DE DATABASE');
        brewers = await brewerDAO.getBrewers();
        debugPrint('HAY POLAS ${brewers.length}');
        //await shouldUpdateData()
        if (brewers.isNotEmpty) {
          brewerTakenFromDB = true;
          beers = await beersDAO.getBeers();
          tastedBeers = await getMyTastedBeers();
          hideLoading();
          if (kDebugMode) {
            print(beers.length);
            print(brewers.length);
          }
          hideLoading();
        }
        fetchBrewersAndBeers();
      }
    } catch (exception, stacktrace) {
      debugPrint("$stacktrace");
      hideLoading();
    }
  }

  void fetchBrewersAndBeers() async {
    try {
      debugPrint('TOMANDO DATOS DE INTERNET');
      var response = await api.fetchBrewers();
      if (response.statusCode == 200) {
        //setFetchCurrentDate();
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        beers.clear();
        brewers.clear();
        for (Map brewer in jsonData) {
          var brewerObj = Brewer.fromJson(brewer);
          beers.addAll(brewerObj.beers);
          brewers.add(brewerObj);
        }
        if (kDebugMode) {
          print(beers.length);
          print(brewers.length);
        }
        brewerDAO.insertBrewers(brewers);
      }
      hideLoading();
    } catch (exception, stacktrace) {
      debugPrint('ERROR FETCHING BEERS, BEERS ON DB $brewerTakenFromDB');
      if (!brewerTakenFromDB) {
        debugPrint('NO BEERS AND ERROR FETCHING BREWERS');
        debugPrint('tryAgain Seconds $tryAgainSeconds');
        Future.delayed(
            Duration(seconds: tryAgainSeconds), fetchBrewersAndBeers);
        if (tryAgainSeconds <= 40) {
          tryAgainSeconds += tryAgainSeconds;
        }
      }
      print(stacktrace);
      hideLoading();
    }
  }

  void changeCurrentBrewerFavoriteState() {
    currentBrewer.favorite = !currentBrewer.favorite;
    notifyListeners();
  }

  void saveCurrentBrewerFavoriteState() {
    brewerDAO.setFavorite(currentBrewer);
  }

  void setFetchCurrentDate() async {
    SharedPreferences prefs = await getSharedPreference();
    String lastUpdate = DateFormat.yMMMMd().format(DateTime.now());
    prefs.setString('last_update', lastUpdate);
  }

  Future<bool> shouldUpdateData() async {
    SharedPreferences prefs = await getSharedPreference();
    String lastUpdate = (prefs.getString('last_update'));
    try {
      if (lastUpdate != null &&
          DateTime.parse(lastUpdate).difference(DateTime.now()).inDays >
              CACHE_TIME_IN_DAYS) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception);
      return true;
    }
  }

  ///Top Beers
  Future<List<Beer>> fetchTopBeers() async {
    beers.sort((a, b) => a.ranking.compareTo(b.ranking));
    return beers.sublist(0, beers.length >= 5 ? 5 : beers.length);
  }

  void sendBeerFeedback(Beer beer) async {
    var index = beers.indexWhere((element) => element.id == beer.id);
    debugPrint('INDEX BEER $index');
    beers[index] = beer;
    if (beer.doITasted) {
      tastedBeers.add(beer);
    } else {
      tastedBeers.removeWhere((element) => element.id == beer.id);
    }
    beersDAO.updateBeer(beer);
    notifyListeners();
  }

  Future<Brewer> getBrewerById(int brewerId) async {
    currentBrewer = await Future.microtask(
        () => brewers.where((brewer) => brewer.id == brewerId).first);
    return currentBrewer;
  }

  Future<List<Beer>> getMyTastedBeers() async {
    return await beersDAO.getMyTastedBeers();
  }

  Future<List<Beer>> fetchBeersByCategory(List<int> categoryId) async {
    return await beersDAO.getBeersFromCategory(categoryId);
  }
}
