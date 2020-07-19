import 'dart:async';

import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/brewer_dao.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

const kLastUpdate = "last_update";

class BrewersData extends BaseProvider {
  static const CACHE_TIME_IN_DAYS = 1;

  List<Brewer> brewers = List();
  List<Beer> beers = List();
  Brewer currentBrewer;
  List<Beer> tastedBeers = List();
  bool brewerTakenFromDB = false;
  int tryAgainSeconds = 5;

  final api = Api();
  final brewerDAO = BrewerDao();
  final beersDAO = BeersDao();
  final baseCacheManager = DefaultCacheManager();

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  /*
  * Analytics
   */
  Future<void> sendBuyEvent() async {
    await analytics.logEvent(name: 'BUY', parameters: <String, dynamic>{
      'brewer' : currentBrewer.name,
    });
  }

  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  static final BrewersData _singleton = BrewersData._internal();

  factory BrewersData() {
    return _singleton;
  }

  BrewersData._internal() {
    getBrewers();
  }

  Future<void> getBrewersAndBeersFromDB() async {
    debugPrint('TOMANDO DATOS DE DATABASE');
    brewers = await brewerDAO.getBrewers();
    debugPrint('HAY POLAS ${brewers.length}');
    if (brewers.isNotEmpty) {
      brewerTakenFromDB = true;
      beers = await beersDAO.getBeers();
      tastedBeers = await getMyTastedBeers();
      debugPrint("${beers.length}");
      debugPrint("${brewers.length}");
      hideLoading();
    }
  }

  Future<void> getBrewers() async {
    try {
      showLoading();
      if (brewers.isEmpty) {
        await getBrewersAndBeersFromDB();
        if (await shouldUpdateData()) {
          fetchBrewersAndBeers();
        }
      }
    } catch (exception, stacktrace) {
      debugPrint("$stacktrace");
      hideLoading();
    }
  }

  List<Brewer> brewersAndBeersFromJsonConvert(dynamic jsonData) {
    List<Brewer> brewers = List();
    for (Map brewer in jsonData) {
      var brewerObj = Brewer.fromJson(brewer);
      brewers.add(brewerObj);
    }
    return brewers;
  }

  Future<void> fetchBrewersAndBeers() async {
    try {
      debugPrint('TOMANDO DATOS DE INTERNET');
      var response = await api.fetchBrewers();
      if (response.statusCode == 200) {
        setFetchCurrentDate();
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        var brewersFromJson = brewersAndBeersFromJsonConvert(jsonData);
        await brewerDAO.insertBrewers(brewersFromJson);
        debugPrint('NUEVAS CERVEZAS INSERTADAS EN DATOS DE DATABASE');
        await getBrewersAndBeersFromDB();
      }
      if (!brewerTakenFromDB) {
        hideLoading();
      }
    } catch (exception, stacktrace) {
      debugPrint('ERROR FETCHING BEERS, BEERS ON DB $brewerTakenFromDB');
      if (!brewerTakenFromDB) {
        hideLoading();
        debugPrint('NO BEERS AND ERROR FETCHING BREWERS');
        debugPrint('tryAgain Seconds $tryAgainSeconds');
        Future.delayed(
            Duration(seconds: tryAgainSeconds), fetchBrewersAndBeers);
        if (tryAgainSeconds <= 20) {
          tryAgainSeconds += tryAgainSeconds;
        }
      }
      print(stacktrace);
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
    prefs.setString(kLastUpdate, lastUpdate);
  }

  Future<bool> shouldUpdateData() async {
    return true;
    /*SharedPreferences prefs = await getSharedPreference();
    String lastUpdate = (prefs.getString(kLastUpdate));
    debugPrint('========LAST UPDATE========');
    debugPrint(lastUpdate);
    try {
      var shouldUpdate = lastUpdate == null ||
          lastUpdate.isEmpty ||
          DateFormat.yMMMMd()
                  .parse(lastUpdate)
                  .difference(DateTime.now())
                  .inDays >
              CACHE_TIME_IN_DAYS;
      debugPrint('UPDATE $shouldUpdate');
      return shouldUpdate;
    } catch (exception) {
      debugPrint(exception);
      return true;
    }*/
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
    currentBrewer = brewers.where((brewer) => brewer.id == brewerId).first;
    return currentBrewer;
  }

  Future<List<Beer>> getMyTastedBeers() async {
    return await beersDAO.getMyTastedBeers();
  }

  Future<List<Beer>> fetchBeersByCategory(List<int> categoryId) async {
    return await beersDAO.getBeersFromCategory(categoryId);
  }

  bool calledClearCache = false;
  Future<void> clearCache() async {
    if(!calledClearCache) {
      calledClearCache = true;
      baseCacheManager.emptyCache();
      fetchBrewersAndBeers();
    }
  }
}
