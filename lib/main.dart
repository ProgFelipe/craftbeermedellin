import 'package:craftbeer/app_localization.dart';
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
  final List<Widget> _children = [Home(), EventsView(), Favorites()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.brown,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
                color: Colors.amber[700],
              ),
              title: Text(
                localizedText(context, HOME),
                style: TextStyle(color: Colors.amber[700]),
              ),
              backgroundColor: Colors.brown),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            activeIcon: Icon(
              Icons.receipt,
              color: Colors.blue[700],
            ),
            backgroundColor: Colors.blueGrey,
            title: Text(
              localizedText(context, EVENTS),
              style: TextStyle(color: Colors.blue[700]),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            backgroundColor: Colors.blueGrey,
            title: Text(localizedText(context, FAVORITES),
                style: TextStyle(color: Colors.red[700])),
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
