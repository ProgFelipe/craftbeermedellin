import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBloc {
  Future<bool> isFavorite(brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('favorites') ?? List()).contains(brewerName);
  }

  changeFavorite(bool isFavorite, String brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites != null ?? favorites.contains(brewerName);
    isFavorite ? favorites.remove(brewerName) : favorites.add(brewerName);
    print('Brewer is favorite: $exist ?.');
    await prefs.setStringList('favorites', favorites);
  }

  Color fetchBeerColor(String type) {
    switch (type.toLowerCase()) {
      case 'ipa':
        return Colors.orange;
      case 'pale ale':
        return Colors.orange[500];
      case 'stout':
        return Colors.brown[700];
      case 'pilsen':
        return Colors.yellow[500];
      case 'porter':
        return Colors.black54;
      case 'amber':
        return Colors.orange[400];
      case 'doppelbock':
        return Colors.brown;
      case 'bock':
        return Colors.yellow[300];
      case 'dunkel':
        return Colors.brown[700];
      case 'marzen':
        return Colors.orange[200];
      case 'raunchbier':
        return Colors.orangeAccent;
      case 'weizenbier':
        return Colors.yellow[600];
      case 'weizenbock':
        return Colors.brown[400];
      case 'kÖlsh':
        return Colors.yellow;
      default:
        return Colors.orange;
    }
  }
}
