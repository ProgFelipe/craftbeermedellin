import 'package:flutter/material.dart';

import './famousrecipies.dart';
import './Home/home.dart';
import './event_map.dart';


void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Cerveceros Medellin',
      theme:  ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.brown,
      ),
      home:  Navigator(),
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
  final List<Widget> _children = [Home(), Store(), Store(), EventMap()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerveceros', style:  TextStyle(fontFamily: 'Faster', fontSize: 28.0),),
        backgroundColor: Colors.brown,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.brown,
        onTap: onTabTapped, // 
        currentIndex: _currentIndex, // 
        items: [
          BottomNavigationBarItem(
            icon:  Icon(Icons.home),
            activeIcon: Icon(Icons.home, color: Colors.blue[700],),
            title:  Text('Home', style: TextStyle(color: Colors.blue[700]),),
            backgroundColor: Colors.brown
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.receipt),
            activeIcon: Icon(Icons.receipt, color: Colors.amber[700],),
            backgroundColor: Colors.blueGrey,
            title:  Text('Compras'),
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.favorite),
            activeIcon: Icon(Icons.favorite, color: Colors.red,),
            backgroundColor: Colors.blueGrey,
            title:  Text('Favoritas'),
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.filter_hdr),
            activeIcon: Icon(Icons.filter_hdr, color: Colors.green,),
            backgroundColor: Colors.grey,
            title:  Text('Eventos'),
          )
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

