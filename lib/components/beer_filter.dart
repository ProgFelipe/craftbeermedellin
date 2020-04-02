import 'dart:math';
import 'dart:ui';

import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/home/brewers_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> beerFavorites = [
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol',
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol'
];
const List<String> beerCategories = [
  'IPA',
  'PORTER',
  'SOUT',
  'IPA',
  'PORTER',
  'SOUT'
];

Widget buildCategorySearch(bool category) {
  return Container(
    height: 120.0,
    decoration: BoxDecoration(),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: category ? beerCategories.length : beerFavorites.length,
      itemBuilder: (context, index) => Container(
        height: 120.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: category
                ? [Colors.black54, Colors.indigo]
                : [Colors.deepOrange, Colors.yellow],
          ),
        ),
        child: FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BrewersDetail(index)));
          },
          child: Image.asset(getImageBeerCategory()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    ),
  );
}

Widget topBeersOfWeek() {
  return Container(
    height: 100.0,
    decoration: BoxDecoration(),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: beerFavorites.length,
      itemBuilder: (context, index) => beerCard(),
    ),
  );
}

Widget beerCard() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    /*decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.black38])),*/
    child: Card(
      elevation: 20.0,
      child: Image.asset(
        'assets/beer.png',
        height: 60.0,
      ),
    ),
  );
}

String getImageBeerCategory() {
  int result = Random().nextInt(2);
  switch (result) {
    case 0:
      return 'assets/beertype.png';
    case 1:
      return 'assets/beertype2.png';
    default:
      return 'assets/beertype.png';
  }
}
