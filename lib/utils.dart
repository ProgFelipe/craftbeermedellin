import 'package:craftbeer/app_localization.dart';
import 'package:flutter/material.dart';

Widget titleView(String title,
    {Color color = Colors.white, double size = 50.0}) {
  return Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        title,
        style: TextStyle(fontFamily: 'Blessed', fontSize: size, color: color),
        textAlign: TextAlign.left,
      ));
}

///Localization
const String HOME = "home";
const String EVENTS = "events";
const String FAVORITES = "favorites";
const String NO_DATA_ERROR = "no_data";
const String LOCAL_BREWERS_TITLE = "local_brewers";
const String WELCOME = "welcome_story_telling";
String localizedText(context, String key) {
  debugPrint(AppLocalizations.of(context).translate(key));
  return AppLocalizations.of(context).translate(key);
}
