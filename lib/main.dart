import 'package:connectivity/connectivity.dart';
import 'package:craftbeer/categories/beer_category_view.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/events/events_view.dart';
import 'package:craftbeer/map/map_view.dart';
import 'package:craftbeer/models.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './Home/home_view.dart';
import 'generated/l10n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final database = DataBaseService();
  final connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>.value(
            value: connectivity.onConnectivityChanged),
        FutureProvider<List<Beer>>.value(value: database.fetchBeers()),
        FutureProvider<List<BeerType>>.value(value: database.fetchBeerTypes()),
        FutureProvider<List<Brewer>>.value(value: database.fetchBrewers()),
        //StreamProvider<List<Beer>>.value(value: database.streamBeers()),
        StreamProvider<List<Release>>.value(value: database.fetchReleases()),
        //StreamProvider<List<Brewer>>.value(value: database.streamBrewers()),
        //StreamProvider<List<BeerType>>.value(value: database.streamBeerTypes()),
        StreamProvider<List<Promotion>>.value(
            value: database.streamPromotions()),
        StreamProvider<List<Event>>.value(value: database.streamEvents()),
      ],
      child: MaterialApp(
        title: 'Craft Beer Colombia',
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
            primarySwatch: Colors.orange,
            cursorColor: Colors.orange,
            fontFamily: 'Patua',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        home: SplashScreen.navigate(
          name: 'assets/splash.flr',
          next: (context) => Navigator(),
          until: () => Future.delayed(Duration(seconds: 3)),
          startAnimation: 'Splash',
          backgroundColor: Colors.white,
        ),
      ),
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
  PageController _pageController;
  final List<Widget> screens = [
    Home(),
    EventsView(),
    BeerCategoryView(),
    CraftMap()
  ];

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentIndex,
    );
    super.initState();
  }

  /*
  IndexedStack(
          index: _currentIndex,
          children: widget.screens,
        )
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: _currentIndex == 3 ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        //physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            this._currentIndex = newPage;
          });
        },
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.brown,
        onTap: (index) {
          this._pageController.animateToPage(index,
              duration: Duration(microseconds: 500), curve: Curves.easeInOut);
        },
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: Text(S.of(context).home_nav_title),
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
            title: Text(S.of(context).events_nav_title),
          ),
          BottomNavigationBarItem(
            icon: Icon(BeerIcon.beerglass),
            activeIcon: Icon(
              BeerIcon.beerglass,
              color: Colors.orangeAccent,
            ),
            backgroundColor: Colors.black,
            title: Text(S.of(context).beer_nav_title),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(
              Icons.map,
              color: Colors.green,
            ),
            backgroundColor: Colors.black,
            title: Text('Mapa'),
          ),
        ],
      ),
    );
  }
}
