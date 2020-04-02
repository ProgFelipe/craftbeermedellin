import 'package:craftbeer/app_localization.dart';
import 'package:craftbeer/categories/beer_category.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/events/events_view.dart';
import 'package:craftbeer/favorites/favorites_view.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './Home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craft Beer Colombia',
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Navigator(),
    );
  }
}

class Navigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigatorState();
  }
}

class _NavigatorState extends State<Navigator> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    EventsView(),
    BeerCategory(),
    Favorites()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.brown,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
                localizedText(context, HOME),
                style: TextStyle(color: Colors.white),
              ),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            activeIcon: Icon(
              Icons.receipt,
              color: Colors.red[500],
            ),
            backgroundColor: Colors.black,
            title: Text(
              localizedText(context, EVENTS),
              style: TextStyle(color: Colors.red[400]),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(BeerIcon.beerglass),
            activeIcon: Icon(
              BeerIcon.beerglass,
              color: Colors.orangeAccent,
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Beer',
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
            backgroundColor: Colors.orangeAccent,
            title: Text(localizedText(context, FAVORITES),
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
