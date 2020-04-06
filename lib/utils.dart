import 'package:craftbeer/app_localization.dart';
import 'package:flutter/material.dart';

Widget titleView(String title,
    {Color color = Colors.white, double size = 30.0, double padding = 20.0}) {
  return Container(
    width: double.infinity,
    child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          title,
          style: TextStyle(fontFamily: 'Patua', fontSize: size, color: color),
          textAlign: TextAlign.left,
        )),
  );
}

///Localization
const String HOME_NAV_TITLE = "home_nav_title";
const String EVENTS_NAV_TITLE = "events_nav_title";
const String BEER_NAV_TITLE = "beer_nav_title";
const String FAVORITES_NAV_TITLE = "favorites_nav_title";
const String NO_DATA_ERROR = "no_data";
const String LOCAL_BREWERS_TITLE = "local_brewers";
const String WELCOME = "welcome_story_telling";
const String PROMOTIONS_TITLE = "promotions_title";
const String EVENTS_TITLE = "events_title";
String localizedText(context, String key) {
  return AppLocalizations.of(context).translate(key);
}
