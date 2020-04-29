import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class BeersData extends ChangeNotifier{
  List<Beer> beers = List();
  final api = DataBaseService();

  BeersData(){
    getBeers();
  }

  getBeers() async {
    try {
      var response = await api.fetchBeers();
      switch (response.statusCode) {
        case 200:
          {
            //[beer1, beer2, beer3, ...]
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            //var beers = jsonData.map((beer){Beer.fromJson(beer);}).toList();
            for (Map beer in jsonData) {
              beers.add(Beer.fromJson(beer));
            }
            notifyListeners();
            return;
          }
        case 404:
          {
            return;
          }
        case 500:
          {
            return;
          }
      }
    }catch(exception){

    }
  }

  setBeerAsTasted(int index){

    //beers[index] = true;
    notifyListeners();
  }

  setBeerAsNotTasted(int index){
    //beers[index].tasted = false;
    notifyListeners();
  }
}