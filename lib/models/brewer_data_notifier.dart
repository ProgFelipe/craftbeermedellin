import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class BrewersData extends ChangeNotifier {
  List<Brewer> brewers;
  bool underMaintain = false;
  bool checkYourInternet = false;
  bool errorStatus = false;
  final api = DataBaseService();

  BrewersData(){
    getBrewers();
  }
  //final db = localDataBase();
  void getBrewers() async {
    try {
      if(brewers == null || brewers.isEmpty) {
        var response = await api.fetchBrewers();
        switch(response.statusCode){
          case 200: {
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            print(jsonData);
            List<Brewer> brewers = List();
            for (Map brewer in jsonData) {
              brewers.add(Brewer.fromJson(brewer));
            }
            underMaintain = false;
            checkYourInternet = false;
            addBrewers(brewers);
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
      errorStatus = true;
      notifyListeners();
    }
    //Return cache if exist
    //Retry with back pressure if not service in maintaince
  }

  void addBrewers(List<Brewer> newBrewers) {
    brewers = newBrewers;
    notifyListeners();
  }

  void setBrewerToFavorite(Brewer brewer) {}
}
