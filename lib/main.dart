import 'package:flutter/material.dart';

import 'store/store.dart';
import './Home/home.dart';
import 'Events/events.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craft Beer Colombia',
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
    Events(),
    Store(),
    Events()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.brown,
        onTap: onTabTapped, //
        currentIndex: _currentIndex, //
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
                color: Colors.blue[700],
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.blue[700]),
              ),
              backgroundColor: Colors.brown),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_hdr),
            activeIcon: Icon(
              Icons.filter_hdr,
              color: Colors.green,
            ),
            backgroundColor: Colors.grey,
            title: Text('Eventos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            activeIcon: Icon(
              Icons.receipt,
              color: Colors.amber[700],
            ),
            backgroundColor: Colors.blueGrey,
            title: Text('Compras'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            backgroundColor: Colors.blueGrey,
            title: Text('Favoritas'),
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
