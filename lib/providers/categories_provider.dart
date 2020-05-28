import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/category_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class CategoriesData extends BaseProvider {
  List<BeerType> categories = List();
  List<Beer> selectedCategoryBeers;
  final api = Api();

  BeerType selectedCategory;

  void updateSelection(BeerType newSelection) {
    selectedCategory = newSelection;
    notifyListeners();
  }


  static final CategoriesData _singleton = CategoriesData._internal();

  factory CategoriesData() {
    return _singleton;
  }

  CategoriesData._internal(){
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      var response = await api.fetchBeerTypes();
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        for (Map beerType in jsonData) {
          categories.add(BeerType.fromJson(beerType));
        }
        debugPrint('CATEGORIAS');
        debugPrint("${categories.length}");
      }
      hideLoading();
    } catch (exception, stacktrace) {
      debugPrint("$stacktrace");
      hideLoading();
    }
  }
}
