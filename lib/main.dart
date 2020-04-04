import 'package:craftbeer/app_localization.dart';
import 'package:craftbeer/categories/beer_category.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/events/events_view.dart';
import 'package:craftbeer/favorites/favorites_view.dart';
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
        primarySwatch: Colors.orange,
        cursorColor: Colors.orange,
      ),
      home: Navigator(),
    );
  }
}

class Navigator extends StatefulWidget {
  final List<Widget> screens = [
    Home(
      key: PageStorageKey('HomePage'),
    ),
    EventsView(
      key: PageStorageKey('EventPage'),
    ),
    BeerCategory(
      key: PageStorageKey('BeerCategoryPage'),
    ),
    Favorites(
      key: PageStorageKey('FavoritesPage'),
    )
  ];
  @override
  State<StatefulWidget> createState() {
    return _NavigatorState();
  }
}

class _NavigatorState extends State<Navigator> {
  final PageStorageBucket bucket = PageStorageBucket();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Text subtree = const Text("Hello World");
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.brown,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text('Home'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            activeIcon: Icon(
              Icons.receipt,
              //color: Colors.red[500],
              color: Colors.red,
            ),
            backgroundColor: Colors.black,
            title: Text('Events'),
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
            backgroundColor: Colors.black,
            title: Text('Favorites'),
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
