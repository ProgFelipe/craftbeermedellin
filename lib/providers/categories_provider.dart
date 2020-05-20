import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/category_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class CategoriesData extends ChangeNotifier{
  List<BeerType> categories = List();
  List<Beer> selectedCategoryBeers;
  final api = DataBaseService();

  BeerType selectedCategory;

  void updateSelection(BeerType newSelection){
    selectedCategory = newSelection;
    notifyListeners();
  }

  CategoriesData(){
    getCategories();
  }

  void getCategories() async {
    try {
      var response = await api.fetchBeerTypes();
      switch(response.statusCode){
        case 200: {
          print('CATEGORIAS');
          try {
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            for (Map beerType in jsonData) {
              categories.add(BeerType.fromJson(beerType));
            }
            print('CATEGORIAS');
            print(categories.length);
            notifyListeners();
          }catch(e, stacktrace){
            print(stacktrace);
          }
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

}