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
  List<Brewer> brewers;
  List<Beer> beers;
  bool underMaintain = false;
  bool checkYourInternet = false;
  bool errorStatus = false;
  final api = DataBaseService();
  final brewerDAO = BrewerDao();
  final beersDAO = BeersDao();

  static const CACHE_TIME_IN_DAYS = 3;

  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  BrewersData(){
    getBrewers();
  }

  void getBrewers() async {
    try {
      if(brewers?.isEmpty ?? true) {
        debugPrint('TOMANDO DATOS DE DATABASE');
        brewers = await brewerDAO.getBrewers();
        beers = await beersDAO.getBeers();
        //await shouldUpdateData()
        if (brewers?.isEmpty ?? true) {
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
                underMaintain = false;
                checkYourInternet = false;
                addBrewers(brewers, beers);
                return;
              }
            case 404:
              {
                print('404');
                underMaintain = true;
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
        }else{
          addBrewers(brewers, beers);
        }
      }
    } catch (exception, stacktrace) {
      print(stacktrace);
      errorStatus = true;
      notifyListeners();
    }
  }

  void addBrewers(List<Brewer> newBrewers, List<Beer> newBeers) {
    brewers = newBrewers;
    beers = newBeers;
    print(beers.length);
    print(brewers.length);
    notifyListeners();
  }

  void setBrewerToFavorite(Brewer brewer, bool isFavorite) {
    brewerDAO.setFavorite(brewer, isFavorite);
  }

  void setBeerTastedValue(Beer beer, bool tasted){
    beersDAO.setTasted(beer, tasted);
  }

  void setFetchCurrentDate() async {
    SharedPreferences prefs = await getSharedPreference();
    String lastUpdate = DateFormat.yMMMMd().format(DateTime.now());
    prefs.setString('last_update', lastUpdate);
  }

  Future<bool> shouldUpdateData() async {
    SharedPreferences prefs = await getSharedPreference();
    String lastUpdate = (prefs.getString('last_update'));
    try{
      if(lastUpdate != null && DateTime.parse(lastUpdate).difference(DateTime.now()).inDays > CACHE_TIME_IN_DAYS){
        return true;
      }else{
        return false;
      }
    }catch(exception){
      print(exception);
      return true;
    }
  }

}
