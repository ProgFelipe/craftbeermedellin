import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/category_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'dart:convert';

class CategoriesData extends BaseProvider {
  List<BeerType> categories = List();
  List<Beer> selectedCategoryBeers;
  final api = DataBaseService();

  BeerType selectedCategory;

  void updateSelection(BeerType newSelection) {
    selectedCategory = newSelection;
    notifyListeners();
  }

  CategoriesData() {
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      var response = await api.fetchBeerTypes();
      switch (response.statusCode) {
        case 200:
          {
            print('CATEGORIAS');
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            for (Map beerType in jsonData) {
              categories.add(BeerType.fromJson(beerType));
            }
            print('CATEGORIAS');
            print(categories.length);
            underMaintainState = false;
            checkYourInternet = false;
            errorStatus = false;
            loadingState = false;
            notifyListeners();
            return;
          }
        case 404:
          {
            underMaintainState = true;
            loadingState = false;
            notifyListeners();
            return;
          }
        case 500:
          {
            checkYourInternet = true;
            loadingState = false;
            notifyListeners();
            return;
          }
      }
    } catch (exception, stacktrace) {
      print(stacktrace);
      errorStatus = true;
      hideLoading();
    }
  }
}
