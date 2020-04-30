import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/database/beers_dao.dart';
import 'package:craftbeer/database/brewer_dao.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BrewersData extends ChangeNotifier {
  List<Brewer> brewers;
  List<Beer> beers;
  bool underMaintain = false;
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

  BrewersData(){
    getBrewers();
  }

  void getBrewers() async {
    try {
      brewers = await brewerDAO.getBrewers();
      beers = await beersDAO.getBeers();
      if(brewers == null || brewers.isEmpty || beers?.isEmpty == true) {
        var response = await api.fetchBrewers();
        switch(response.statusCode){
          case 200: {
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            print(jsonData);
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
          case 404: {
            print('404');
            underMaintain = true;
            notifyListeners();
            return;
          }
          case 503:{
            print('503');
            checkYourInternet = true;
            notifyListeners();
            return;
          }
        }
      }
    } catch (exception) {
      print(exception);
      errorStatus = true;
      notifyListeners();
    }
    //Return cache if exist
    //Retry with back pressure if not service in maintaince
  }

  void addBrewers(List<Brewer> newBrewers, List<Beer> newBeers) {
    brewers = newBrewers;
    beers = newBeers;
    print('NUMERO DE CERVECEROS ${brewers.length}');
    print('NUMERO DE CERVEZAS ${beers.length}');
    notifyListeners();
  }

  void setBrewerToFavorite(Brewer brewer) {}
}
