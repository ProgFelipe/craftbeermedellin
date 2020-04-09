// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get home_nav_title {
    return Intl.message(
      'Home',
      name: 'home_nav_title',
      desc: '',
      args: [],
    );
  }

  String get events_nav_title {
    return Intl.message(
      'Events',
      name: 'events_nav_title',
      desc: '',
      args: [],
    );
  }

  String get beer_nav_title {
    return Intl.message(
      'Beer',
      name: 'beer_nav_title',
      desc: '',
      args: [],
    );
  }

  String get favorites_nav_title {
    return Intl.message(
      'Favorites',
      name: 'favorites_nav_title',
      desc: '',
      args: [],
    );
  }

  String get no_data {
    return Intl.message(
      'No internet connection',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  String get local_brewers {
    return Intl.message(
      'Local Brewers',
      name: 'local_brewers',
      desc: '',
      args: [],
    );
  }

  String get welcome_story_telling {
    return Intl.message(
      'Welcome\nLocal Colombian Brewers.!\n\nThe Craft Beer is our pasion \n\nDiscover local Craft Beers!',
      name: 'welcome_story_telling',
      desc: '',
      args: [],
    );
  }

  String get promotions_title {
    return Intl.message(
      'Promotions',
      name: 'promotions_title',
      desc: '',
      args: [],
    );
  }

  String get events_title {
    return Intl.message(
      'Local Events',
      name: 'events_title',
      desc: '',
      args: [],
    );
  }

  String get top_week_title {
    return Intl.message(
      'Top Week Selections',
      name: 'top_week_title',
      desc: '',
      args: [],
    );
  }

  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  String get hours {
    return Intl.message(
      'Hrs',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  String get more_info {
    return Intl.message(
      'More info',
      name: 'more_info',
      desc: '',
      args: [],
    );
  }

  String get ibu {
    return Intl.message(
      'IBU:',
      name: 'ibu',
      desc: '',
      args: [],
    );
  }

  String get abv {
    return Intl.message(
      'ABV:',
      name: 'abv',
      desc: '',
      args: [],
    );
  }

  String get know_us {
    return Intl.message(
      'Know about us',
      name: 'know_us',
      desc: '',
      args: [],
    );
  }

  String get request_beer_by_whatsapp {
    return Intl.message(
      'Buy on Whatsapp',
      name: 'request_beer_by_whatsapp',
      desc: '',
      args: [],
    );
  }

  String get offers {
    return Intl.message(
      'Offers',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  String get our_beers {
    return Intl.message(
      'Our Beers',
      name: 'our_beers',
      desc: '',
      args: [],
    );
  }

  String get do_you_like_it {
    return Intl.message(
      'Do you like it?',
      name: 'do_you_like_it',
      desc: '',
      args: [],
    );
  }

  String get find_beer_or_brewer_hint {
    return Intl.message(
      'Search beer or brewer',
      name: 'find_beer_or_brewer_hint',
      desc: '',
      args: [],
    );
  }

  String get i_would_like_to_to_buy_msg {
    return Intl.message(
      'I would like to buy beers',
      name: 'i_would_like_to_to_buy_msg',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}