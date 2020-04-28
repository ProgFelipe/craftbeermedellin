import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class CategoriesData extends ChangeNotifier{
  List<BeerType> categories = List();
  List<Beer> selectedCategoryBeers;
  final api = DataBaseService();

  CategoriesData(){
    getCategories();
  }

  void getCategories() async {
    try {
      var response = await api.fetchBeerTypes();
      switch(response.statusCode){
        case 200: {
            //[beer1, beer2, beer3, ...]
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            for (Map beerType in jsonData) {
              categories.add(BeerType.fromJson(beerType));
            }
            notifyListeners();
            return;
        }
        case 404: {
          return;
        }
        case 500: {
          return;
        }
      }
    }catch(exception){

    }

  }
  
  void onSelectCategory(CategoryBeer categoryBeer){

  }
}