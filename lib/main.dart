import 'package:craftbeer/app_localization.dart';
import 'package:craftbeer/categories/beer_category_view.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/events/events_view.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './Home/home_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final database = DataBaseService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Beer>>.value(
            value: database.fetchTopBeers()),
        StreamProvider<List<Brewer>>.value(
            value: database.streamBrewers()),
        StreamProvider<List<BeerType>>.value(
            value: database.streamBeerTypes()),
        StreamProvider<List<Promotion>>.value(
            value: database.streamPromotions()),
        StreamProvider<List<Event>>.value(
            value: database.streamEvents()),
      ],
      child: MaterialApp(
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
    //Favorites()
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
            title: Text(localizedText(context, HOME_NAV_TITLE)),
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
            title: Text(localizedText(context, EVENTS_NAV_TITLE)),
          ),
          BottomNavigationBarItem(
            icon: Icon(BeerIcon.beerglass),
            activeIcon: Icon(
              BeerIcon.beerglass,
              color: Colors.orangeAccent,
            ),
            backgroundColor: Colors.black,
            title: Text(
              localizedText(context, BEER_NAV_TITLE),
            ),
          ),
        ],
      ),
    );
  }
}
