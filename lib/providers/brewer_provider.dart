import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/brewer_dao.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BrewersData extends ChangeNotifier {
  static const CACHE_TIME_IN_DAYS = 3;

  List<Brewer> brewers;
  List<Beer> beers;
  Brewer currentBrewer;
  List<Beer> tastedBeers = List();

  bool underMaintainState = false;
  bool loadingState = false;
  bool checkYourInternet = false;
  bool errorStatus = false;

  final api = DataBaseService();
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

  void showLoading(){
    loadingState = true;
    notifyListeners();
  }

  void hideLoading(){
    loadingState = false;
    notifyListeners();
  }

  void getBrewers() async {
    try {
      showLoading();
      if (brewers?.isEmpty ?? true) {
        debugPrint('TOMANDO DATOS DE DATABASE');
        brewers = await brewerDAO.getBrewers();
        debugPrint('HAY POLAS ${brewers.length}');
        //await shouldUpdateData()
        if (brewers == null || brewers.isEmpty) {
          debugPrint('TOMANDO DATOS DE INTERNET');
          var response = await api.fetchBrewers();
          switch (response.statusCode) {
            case 200:
              {
                setFetchCurrentDate();
                final jsonData = json.decode(utf8.decode(response.bodyBytes));
                List<Brewer> brewers = List();
                List<Beer> beers = List();
                for (Map brewer in jsonData) {
                  var brewerObj = Brewer.fromJson(brewer);
                  beers.addAll(brewerObj.beers);
                  brewers.add(Brewer.fromJson(brewer));
                }
                brewerDAO.insertBrewers(brewers);
                underMaintainState = false;
                checkYourInternet = false;
                addBrewers(brewers, beers);
                return;
              }
            case 404:
              {
                print('404');
                underMaintainState = true;
                notifyListeners();
                return;
              }
            case 503:
              {
                print('503');
                checkYourInternet = true;
                notifyListeners();
                return;
              }
          }
        } else {
          beers = await beersDAO.getBeers();
          tastedBeers = await getMyTastedBeers();
          addBrewers(brewers, beers);
        }
      }
      hideLoading();
    } catch (exception, stacktrace) {
      print(stacktrace);
      errorStatus = true;
      hideLoading();
    }
  }

  void addBrewers(List<Brewer> newBrewers, List<Beer> newBeers) {
    brewers = newBrewers;
    beers = newBeers;
    print(beers.length);
    print(brewers.length);
    notifyListeners();
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

  void sendBeerFeedback(Beer beer, int index) async {
    currentBrewer.beers[index] = beer;
    if (beer.doITasted) {
      tastedBeers.add(beer);
    } else {
      tastedBeers.remove(beer);
    }
    beersDAO.updateBeer(beer);
    notifyListeners();
  }

  Future<Brewer> getBrewerById(int brewerId) async {
    currentBrewer = await Future.microtask(() => brewers.where((brewer) => brewer.id == brewerId).first);
    //currentBrewer = await brewerDAO.fetchBrewerById(brewerId);
    return currentBrewer;
  }

  Future<List<Beer>> getMyTastedBeers() async {
    return await beersDAO.getMyTastedBeers();
  }

  Future<List<Beer>> fetchBeersByCategory(List<int> categoryId) async {
    return await beersDAO.getBeersFromCategory(categoryId);
  }
}
